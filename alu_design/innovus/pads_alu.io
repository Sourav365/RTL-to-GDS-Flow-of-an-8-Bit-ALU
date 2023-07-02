(globals 
   version=3
   io_order = clockwise
   space = 5
   total_edge=8
)

(iopad
    (topleft
      (inst name="CornerCell1" cell=CORNERC offset=0 orientation=R180 place_status=fixed)

     )
     
     (left 
          (inst name="op_code0" cell=XMC place_status=fixed)
          (inst name="op_code1" cell=XMC place_status=fixed)
	    (inst name="op_code2" cell=XMC place_status=fixed)
	    (inst name="clk" cell=XMC place_status=fixed)
	    (inst name="en" cell=XMC place_status=fixed)
          (inst name="VDD" cell=VCCKC place_status=fixed)
	    (inst name="GND" cell=GNDKC place_status=fixed)
	    (inst name="extra_pin1" cell=XMC place_status=fixed)
	    (inst name ="VDDO" cell = VCC3IOC place_status = fixed)
	    (inst name = "GNDO" cell = GNDIOC place_status = fixed)
      )
    (topright
      (inst name="CornerCell2" cell=CORNERC offset=0 orientation=R90 place_status=fixed)

     )
     
     (top 
	    (inst name="A0" cell=XMC place_status=fixed)
          (inst name="A1" cell=XMC place_status=fixed)
          (inst name="A2" cell=XMC place_status=fixed)
          (inst name="A3" cell=XMC place_status=fixed)
	    (inst name="A4" cell=XMC place_status=fixed)
          (inst name="A5" cell=XMC place_status=fixed)
          (inst name="A6" cell=XMC place_status=fixed)
          (inst name="A7" cell=XMC place_status=fixed)
          
      )
    (bottomright
      (inst name="CornerCell3" cell=CORNERC offset=0 orientation=R0 place_status=fixed)

     )
     
     (right 
          (inst name="result0" cell=YA2GSC place_status=fixed)
          (inst name="result1" cell=YA2GSC place_status=fixed)
          (inst name="result2" cell=YA2GSC place_status=fixed)
          (inst name="result3" cell=YA2GSC place_status=fixed)
	    (inst name="result4" cell=YA2GSC place_status=fixed)
          (inst name="result5" cell=YA2GSC place_status=fixed)
          (inst name="result6" cell=YA2GSC place_status=fixed)
          (inst name="result7" cell=YA2GSC place_status=fixed)
          (inst name="flag_carry" cell=YA2GSC place_status=fixed)
	    (inst name="flag_zero" cell=YA2GSC place_status=fixed)
      )
    (bottomleft
      (inst name="CornerCell4" cell=CORNERC offset=0 orientation=R270 place_status=fixed)

     )
     
     (bottom 
	    (inst name="B0" cell=XMC place_status=fixed)
          (inst name="B1" cell=XMC place_status=fixed)
          (inst name="B2" cell=XMC place_status=fixed)
          (inst name="B3" cell=XMC place_status=fixed)
	    (inst name="B4" cell=XMC place_status=fixed)
          (inst name="B5" cell=XMC place_status=fixed)
          (inst name="B6" cell=XMC place_status=fixed)
          (inst name="B7" cell=XMC place_status=fixed)
          
      )

