# APB-INTERFACED-SPI-CORE
APB INTERFACED SPI MASTER CORE TOPOLOGY

# UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
# ------------------------------------------------------------------
# Name                       Type                        Size  Value
# ------------------------------------------------------------------
# uvm_test_top               base_test                   -     @466 
#   envh                     core_env                    -     @473 
#     abp_agth               apb_agent                   -     @480 
#       drvh                 apb_driver                  -     @596 
#         rsp_port           uvm_analysis_port           -     @611 
#         seq_item_port      uvm_seq_item_pull_port      -     @603 
#       monh                 apb_monitor                 -     @728 
#         monitor_port       uvm_analysis_port           -     @735 
#       seqrh                apb_sequencer               -     @619 
#         rsp_export         uvm_analysis_export         -     @626 
#         seq_item_export    uvm_seq_item_pull_imp       -     @720 
#         arbitration_queue  array                       0     -    
#         lock_queue         array                       0     -    
#         num_last_reqs      integral                    32    'd1  
#         num_last_rsps      integral                    32    'd1  
#     sbh                    core_sb                     -     @494 
#       apb_fifo             uvm_tlm_analysis_fifo #(T)  -     @501 
#         analysis_export    uvm_analysis_imp            -     @540 
#         get_ap             uvm_analysis_port           -     @532 
#         get_peek_export    uvm_get_peek_imp            -     @516 
#         put_ap             uvm_analysis_port           -     @524 
#         put_export         uvm_put_imp                 -     @508 
#       spi_fifo             uvm_tlm_analysis_fifo #(T)  -     @548 
#         analysis_export    uvm_analysis_imp            -     @587 
#         get_ap             uvm_analysis_port           -     @579 
#         get_peek_export    uvm_get_peek_imp            -     @563 
#         put_ap             uvm_analysis_port           -     @571 
#         put_export         uvm_put_imp                 -     @555 
#     spi_agth               spi_agent                   -     @487 
#       drvh                 spi_driver                  -     @749 
#         rsp_port           uvm_analysis_port           -     @764 
#         seq_item_port      uvm_seq_item_pull_port      -     @756 
#       monh                 spi_monitor                 -     @881 
#         monitor_port       uvm_analysis_port           -     @888 
#       seqrh                spi_sequencer               -     @772 
#         rsp_export         uvm_analysis_export         -     @779 
#         seq_item_export    uvm_seq_item_pull_imp       -     @873 
#         arbitration_queue  array                       0     -    
#         lock_queue         array                       0     -    
#         num_last_reqs      integral                    32    'd1  
#         num_last_rsps      integral                    32    'd1  
# ------------------------------------------------------------------
