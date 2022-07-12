package terraform.validation

import data.terraform.library as lib
import future.keywords.every
default  allow = false

# Allow all D and E v5 series that have 2-8 CPUs
allowed_vm_sizes_reg_ex := `^Standard_[D,E][2-8]d?s?_v5$`
vm_type := ["azurerm_linux_virtual_machine","azurerm_windows_virtual_machine","azurerm_virtual_machine"]
all_vms := { lib.resources[r].address : vm_size | lib.resources[r].type in vm_type; vm_size := lib.resources[r].values.size }


allowed_vm_sizes[msg] {
    msg := ""
    every k,v in all_vms {
        regex.match(allowed_vm_sizes_reg_ex, v)
        msg = sprintf("VM size violation: %v",k)
    }
    
}

violations[msg] {
  allowed_vm_sizes[msg]
}

allow {
    count(violations) == 0
}