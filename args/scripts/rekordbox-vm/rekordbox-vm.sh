#!/usr/bin/env bash
set -euo pipefail

readonly VM_NAME="rekordbox"
readonly VM_DISK="$HOME/VMs/${VM_NAME}.qcow2"
readonly DISK_SIZE=64
readonly CONNECT="qemu:///session"

vm_exists() {
  virsh --connect "$CONNECT" dominfo "$VM_NAME" &>/dev/null
}

cmd_create() {
  if vm_exists; then
    echo "VM '$VM_NAME' already exists. Use 'start' to launch it."
    exit 1
  fi

  local win_iso="${1:-}"
  if [[ -z "$win_iso" ]]; then
    echo "Usage: rekordbox-vm create <path-to-windows.iso>"
    exit 1
  fi
  if [[ ! -f "$win_iso" ]]; then
    echo "ISO not found: $win_iso"
    exit 1
  fi
  mkdir -p "$HOME/VMs"
  local autounattend_local="$HOME/VMs/autounattend.iso"
  cp --remove-destination "$AUTOUNATTEND_ISO" "$autounattend_local"
  echo "Creating '$VM_NAME' VM (${DISK_SIZE}GB disk, 4GB RAM, 2 vCPUs)..."
  virt-install \
    --connect "$CONNECT" \
    --name "$VM_NAME" \
    --ram 4096 \
    --vcpus 2 \
    --os-variant win10 \
    --disk "path=${VM_DISK},size=${DISK_SIZE},bus=sata,format=qcow2" \
    --cdrom "$win_iso" \
    --disk "${autounattend_local},device=cdrom,readonly=on" \
    --graphics spice,listen=none \
    --video qxl \
    --channel spicevmc \
    --network user,model=e1000e \
    --boot firmware=efi \
    --noautoconsole

  echo "VM created. Opening viewer..."
  virt-viewer --connect "$CONNECT" --attach --wait "$VM_NAME" &
}

cmd_start() {
  if ! vm_exists; then
    echo "VM '$VM_NAME' not found. Run 'rekordbox-vm create <windows.iso>' first."
    exit 1
  fi

  local state
  state=$(virsh --connect "$CONNECT" domstate "$VM_NAME")
  if [[ "$state" == "running" ]]; then
    echo "VM already running, opening viewer..."
  else
    echo "Starting VM..."
    virsh --connect "$CONNECT" start "$VM_NAME"
  fi

  virt-viewer --connect "$CONNECT" --attach --wait "$VM_NAME" &
}

cmd_stop() {
  if ! vm_exists; then
    echo "VM '$VM_NAME' not found."
    exit 1
  fi
  echo "Sending shutdown signal..."
  virsh --connect "$CONNECT" shutdown "$VM_NAME"
}

cmd_kill() {
  if ! vm_exists; then
    echo "VM '$VM_NAME' not found."
    exit 1
  fi
  echo "Force-stopping VM..."
  virsh --connect "$CONNECT" destroy "$VM_NAME"
}

cmd_nuke() {
  if ! vm_exists; then
    echo "VM '$VM_NAME' not found."
    exit 1
  fi
  local state
  state=$(virsh --connect "$CONNECT" domstate "$VM_NAME")
  if [[ "$state" == "running" ]]; then
    echo "Force-stopping VM..."
    virsh --connect "$CONNECT" destroy "$VM_NAME"
  fi
  echo "Undefining VM..."
  virsh --connect "$CONNECT" undefine "$VM_NAME" --nvram 2>/dev/null || \
    virsh --connect "$CONNECT" undefine "$VM_NAME"
  if [[ -f "$VM_DISK" ]]; then
    echo "Deleting disk $VM_DISK..."
    rm -f "$VM_DISK"
  fi
  echo "Done. Run 'rekordbox-vm create <windows.iso>' to start fresh."
}

cmd_status() {
  if ! vm_exists; then
    echo "VM '$VM_NAME' does not exist yet."
    echo "Run 'rekordbox-vm create <windows.iso>' to set it up."
    return
  fi
  virsh --connect "$CONNECT" dominfo "$VM_NAME"
}

case "${1:-}" in
  create) cmd_create "${2:-}" ;;
  start)  cmd_start ;;
  stop)   cmd_stop ;;
  kill)   cmd_kill ;;
  nuke)   cmd_nuke ;;
  status) cmd_status ;;
  *)
    echo "rekordbox-vm — Windows VM manager for Pioneer USB prep"
    echo ""
    echo "Usage: rekordbox-vm <command> [args]"
    echo ""
    echo "Commands:"
    echo "  create <windows.iso>  First-time VM setup"
    echo "  start                 Start VM and open viewer"
    echo "  stop                  Graceful shutdown"
    echo "  kill                  Force stop"
    echo "  nuke                  Remove VM and disk entirely"
    echo "  status                Show VM info"
    exit 1
  ;;
esac
