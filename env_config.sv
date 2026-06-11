/////////////////////////////////////////////////////////////////
// file name : env_config.sv
// description : env configuration object
// Engineer : Ashish Memane
/////////////////////////////////////////////////////////////////

class env_config extends uvm_object;

        // factory registration
        `uvm_object_utils(env_config)

        uvm_active_passive_enum ahb_is_active = UVM_ACTIVE;
        uvm_active_passive_enum apb_is_active = UVM_ACTIVE;

        function new(string name = "env_config");
                super.new(name);
        endfunction : new

endclass : env_config
