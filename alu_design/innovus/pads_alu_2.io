(globals 
   version=2
   io_order = clockwise
   space = 10
   total_edge=8
)

(iopad
    (topleft
      (inst name="CornerCell1" cell=CORNERC offset=0 orientation=R180 place_status=fixed)

     )
     
     (left 
          (inst name="AO")
          (inst name="A1")
          (inst name="A2")
          (inst name="A3")
          (inst name="POWER_VDD" cell=VCC3IOC)
      )
    (topright
      (inst name="CornerCell2" cell=CORNERC offset=0 orientation=R90 place_status=fixed)

     )
     
     (top 
          (inst name="BO")
          (inst name="B1")
          (inst name="B2")
          (inst name="B3")
          (inst name="POWER_VSS" cell=GNDIOC)
      )
    (bottomright
      (inst name="CornerCell3" cell=CORNERC offset=0 orientation=R0 place_status=fixed)

     )
     
     (right 
          (inst name="resultO")
          (inst name="result1")
          (inst name="result2")
          (inst name="result3")
          (inst name="carry")
      )
    (bottomleft
      (inst name="CornerCell4" cell=CORNERC offset=0 orientation=R270 place_status=fixed)

     )
     
     (bottom 
          (inst name="op_code0")
          (inst name="op_code1")
          (inst name="extra_in1" cell=XMC)
          (inst name="POWER_VDD" cell=VCC3IOC)
          (inst name="POWER_VSS" cell=GNDIOC)
      )

