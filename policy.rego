package terraform.validation

import future.keywords.every

resources := { r |
  some path, value

  # Walk over the JSON tree and check if the node we are
  # currently on is a module (either root or child) resources
  # value.
  walk(input.planned_values, [path, value])

  # Look for resources in the current value based on path
  rs := module_resources(path, value)

  # Aggregate them into `resources`
  r := rs[_]
}

# Variant to match root_module resources
module_resources(path, value) = rs {

  # Expect something like:
  #
  #     {
  #     	"root_module": {
  #         	"resources": [...],
  #             ...
  #         }
  #         ...
  #     }
  #
  # Where the path is [..., "root_module", "resources"]

  reverse_index(path, 1) == "resources"
  reverse_index(path, 2) == "root_module"
  rs := value
}

# Variant to match child_modules resources
module_resources(path, value) = rs {

  # Expect something like:
  #
  #     {
  #     	...
  #         "child_modules": [
  #         	{
  #             	"resources": [...],
  #                 ...
  #             },
  #             ...
  #         ]
  #         ...
  #     }
  #
  # Where the path is [..., "child_modules", 0, "resources"]
  # Note that there will always be an index int between `child_modules`
  # and `resources`. We know that walk will only visit each one once,
  # so we shouldn't need to keep track of what the index is.

  reverse_index(path, 1) == "resources"
  reverse_index(path, 3) == "child_modules"
  rs := value
}

reverse_index(path, idx) = value {
	value := path[count(path) - idx]
}

list_contains_value(list, item) {
    list_item = list[_]
    list_item == item
}

# Allow all D and E v5 series that have 2-8 CPUs
allowed_vm_sizes_reg_ex := `^Standard_[D,E][2-8]d?s?_v5$`

vm_type := ["azurerm_linux_virtual_machine","azurerm_windows_virtual_machine","azurerm_virtual_machine"]
all_vms := { resources[r].address : vm_size | resources[r].type in vm_type; vm_size := resources[r].values.size }


vm_size_deny[message] {
    some vm_name, vm_size in all_vms
    not regex.match(allowed_vm_sizes_reg_ex, vm_size)
    
    message := sprintf("VM size '%s' not allowed for VM '%s'", [vm_size, vm_name])
}