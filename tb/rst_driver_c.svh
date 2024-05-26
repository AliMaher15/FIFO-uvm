// Class: rst_drv_c
//
class rst_driver_c extends uvm_driver;

   // var: intf_name
   string  intf_name = "rst_i";
   
   // var: reset_time_ps
   // The length of time, in ps, that reset will stay active
   rand int reset_time_ps;

   `uvm_component_utils_begin(rst_driver_c)
      `uvm_field_string(intf_name,            UVM_ALL_ON)
      `uvm_field_int(reset_time_ps,           UVM_ALL_ON | UVM_DEC)
   `uvm_component_utils_end

   // Base constraints
   constraint rst_cnstr { reset_time_ps inside {[200:500]}; }

   // var: rst_vi
   // Reset virtual interface
   virtual rst_intf rst_vi;

   ////////////////////////////////////////////
   function new(string name="rst_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   ////////////////////////////////////////////
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // get the interface
      uvm_resource_db#(virtual rst_intf)::read_by_name("rst_intf", intf_name, rst_vi);
   endfunction : build_phase

   ////////////////////////////////////////////
   virtual task reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("rst", "Going down.", UVM_NONE)
      rst_vi.res_n <= 0;
      #(reset_time_ps * 1ns);
      rst_vi.res_n <= 1;
      `uvm_info("rst", "Going up.", UVM_NONE)
      phase.drop_objection(this);
   endtask : reset_phase
endclass : rst_driver_c