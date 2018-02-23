rollout CreateSpine "Select Spine Element" width:278 height:106
(
	--Declaration Rollout Parameters
	spinner 'SpinNBones' "" pos:[144,51] width:110 height:16 range:[3,50,5] type:#integer fieldwidth:100 align:#left
	button 'ButtonCreateSpine' "Create Spine" pos:[87,72] width:105 height:21 align:#left
	label 'labelBonesNumer' "Bones Number:" pos:[54,51] width:77 height:13 align:#left
	
	--Setup Rollout Parameters
	local SrtLocal = undefined
	local Hip = undefined 
	local Base = undefined 
	local BaseDepth = undefined 
	local Chest = undefined 
	local ChestDepth = undefined 
	local NBones = 5
	
	on SpinNBones changed i do
	(
		NBones = i
		print NBones
	)
	on ButtonCreateSpine pressed do
	(
		ctrlLocal = rectangle corner_radius:4 length:90 width:90 name:( SetupCharacterName + "_Ctrl_Local") wirecolor:[204,102,12] pos:[0,0,0]
		ctrlGlobal = rectangle corner_radius:4 length:100 width:100 name:( SetupCharacterName + "_Ctrl_Global") wirecolor:[181,197,7] pos:[0,0,0]
		
		SrtLocal = getNodeByName((SetupCharacterName + "_Ctrl_Local"))
		Hip = getNodeByName((SetupCharacterName + "_Guide_Hip"))
		Base = getNodeByName((SetupCharacterName + "_Guide_Base"))
		BaseDepth = getNodeByName((SetupCharacterName + "_Guide_BaseDepth"))
		Chest = getNodeByName((SetupCharacterName + "_Guide_Chest"))
		ChestDepth = getNodeByName((SetupCharacterName + "_Guide_ChestDepth"))
			
		if SrtLocal == undefined or Hip == undefined or Base == undefined or BaseDepth == undefined or Chest == undefined or ChestDepth == undefined 
		then ( print "Some Guides are missing")
		else
		(
			hip = Circle radius:40 name:(SetupCharacterName + "_Ctrl_Hip") wirecolor:[255,0,255] pos:hip.pos 
			base = Point size:20 name:(SetupCharacterName + "_Hlpr_Spine_base") pos:base.pos wirecolor:[255,150,255]  Box:on centermarker:off axistripod:off cross:off
			baseDepth = Circle radius:30 name:(SetupCharacterName + "_Ctrl_Spine_baseDepth") wirecolor:[255,0,255] pos:baseDepth.pos 
			ChestDepth = Circle radius:30 name:(SetupCharacterName + "_Ctrl_Spine_ChestDepth") wirecolor:[255,0,255] pos:ChestDepth.pos 
			Chest = Circle radius:40 name:(SetupCharacterName + "_Ctrl_Spine_Chest") wirecolor:[255,0,255] pos:Chest.pos 
			
			hip.parent = SrtLocal
			Base.parent = Hip
			baseDepth.parent = Base
			ChestDepth.parent = Chest
			Chest.parent = SrtLocal
			
			local CurveSetup = splineshape  name:(SetupCharacterName + "_Hlpr_Spine_Curve") wirecolor:[255,150,255]
			--add spline to spine node in index 1
			addnewspline CurveSetup
			--add knot to spine in index 1
			addknot CurveSetup 1 #corner #curve base.pos
			addknot CurveSetup 1 #corner #curve chest.pos
			--transform knot type from corner to bezier corner
			setknottype CurveSetup 1 1 #beziercorner
			setknottype CurveSetup 1 2 #beziercorner
			--add handle in and out for knot
			setoutvec CurveSetup 1 1 baseDepth.pos
			setinvec CurveSetup 1 2 chestDepth.pos
			--delock curve point to animate
			animatevertex CurveSetup #all
			--Securize curve position with locking transform
			setTransformLockFlags CurveSetup #all
			
			--Skin spline knots to controllers
			CurveSetupKnotCtrl = CurveSetup[#Object__Editable_Spline][#Master].controller
			
			local ScriptKnot1 = point3_Script ()
			ScriptKnot1.addNode "Base" base
			ScriptKnot1.setexpression "Base.pos"
			CurveSetupKnotCtrl[#Spline_1___Vertex_1].controller = ScriptKnot1
			
			local ScriptKnot2 = point3_Script ()
			ScriptKnot2.addNode "Chest" Chest
			ScriptKnot2.setexpression "Chest.pos"
			CurveSetupKnotCtrl[#Spline_1___Vertex_2].controller = ScriptKnot2
			
			local ScriptKnot3 = point3_Script ()
			ScriptKnot3.addNode "BaseDepth" BaseDepth
			ScriptKnot3.setexpression "BaseDepth.pos"
			CurveSetupKnotCtrl[#Spline_1___OutVec_1].controller = ScriptKnot3
			
			local ScriptKnot4 = point3_Script ()
			ScriptKnot4.addNode "ChestDepth" ChestDepth
			ScriptKnot4.setexpression "ChestDepth.pos"
			CurveSetupKnotCtrl[#Spline_1___INVec_2].controller = ScriptKnot4

			----Generate Setup Options
			SpineOption = text name:(SetupCharacterName + "_Options")  size:15 pos:[0,150,225] wirecolor:[255,0,255] text:"Options"
			SpineOption.objectoffsetrot = (eulerangles 90 0 0)
			addModifier SpineOption (EmptyModifier ())
				
			SpineOptionModifier = attributes SpineAtt
			(
				parameters Spine_CustomAttributes rollout:Spine_RolloutAttributes
				(
					CustAttribute_switch type:#float ui:(switchUI) 
					CustAttribute_stretch type:#integer ui:(stretchUI) default:1
					CustAttribute_squash type:#integer ui:(squashUI) default:1
				)
				rollout Spine_RolloutAttributes "Spine"
				(
					Spinner switchUI "switch IK-> FK" type:#float range:[0,1,0] fieldwidth:50 align:#center
					checkbox stretchUI "Stretch"
					checkbox SquashUI "Squash"
				)
				
			)
			
			u = 0.0
			for i in Nbones to 1 by -1 do
			(
				local HlprPosSpine = Point name:(SetupCharacterName + "_Hlpr_Spine_Pos_" + i as string) size:10 wirecolor:[255,150,255] box:off centermarker:off axistripod:off cross:on
				
				local PthCnst = path_constraint path:CurveSetup percent:u
				deletekeys PthCnst.percent.controller #allkeys
				
				HlprPosSpine.position.controller = PthCnst
				
-- 				If i > 1 and i < Nbones then
-- 				(
-- 					local RotScript = float_script ()
-- 					RotScript.addNode "Top" chest
-- 					RotScript.addNode "Base" Hip
-- 					RotScript.addNode "SrtLocal" SrtLocal
-- 					RotScript.addConstant "term" (u/100)
-- 					RotScript.setexpression"
-- 					
-- 					SrtLocalRotZ = SrtLocal.rotation.Z_rotation
-- 					
-- 					BaseRotZ = Base.rotation.controller.Z_Rotation + SrtLocalRotZ
-- 					TopRotZ = Top.rotation.controller.Z_Rotation + SrtLocalRotZ
-- 					
-- 					degtorad((TopRotZ-BaseRotZ) * term + BaseRotZ)
-- 					
-- 					"
-- 					HlprPosSpine.rotation.controller.Z_rotation.controller = RotScript
-- 				)
				
				u += 100.0/(Nbones-1)
			)
			
			
		)
	)
)
	
	

