package terraform.validation

import data.terraform.library as lib
import future.keywords.every
default  allow = false

violations[msg] {
  allowed_vm_sizes[msg]
}

# Allow all D and E v5 series that have 2-8 CPUs
allowed_vm_sizes_reg_ex := `^Standard_[D,E][2-8]d?s?_v5$`

allowed_vm_sizes[msg] {
    vm_sizes := lib.resources[r].values.size
    every vm in vm_sizes {
        regex.match(allowed_vm_sizes_reg_ex, vm)
    }
    msg = sprintf("VM size violation: %v",[r.address])
}

violations[msg] {
  allowed_vm_sizes[msg]
}

allow {
    count(violations) == 0
}