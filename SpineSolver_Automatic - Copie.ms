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
			--Create base Ctrl--
			
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
			
			--Create Curve--
			
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
			
			--Get the knot controller
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
			
			--Create Position Helper--
			
			u = 0.0
			
			for i in 1 to Nbones by 1 do
			(
				
				local HlprPosSpine = Point name:(SetupCharacterName + "_Hlpr_Spine_Pos_" + i as string) size:10 wirecolor:[255,150,255] box:off centermarker:off axistripod:off cross:on
				local PthCnst = path_constraint path:CurveSetup percent:u
				deletekeys PthCnst.percent.controller #allkeys
				HlprPosSpine.position.controller = PthCnst
				
				If i > 1 and i < Nbones then
				(
					local RotScript = float_script ()
					RotScript.addNode "Top" chest
					RotScript.addNode "Base" Hip
					RotScript.addNode "SrtLocal" SrtLocal
					RotScript.addConstant "term" (u/100)
					RotScript.setexpression"
					
					SrtLocalRotZ = SrtLocal.rotation.Z_rotation
					
					BaseRotZ = Base.rotation.controller.Z_Rotation + SrtLocalRotZ
					TopRotZ = Top.rotation.controller.Z_Rotation + SrtLocalRotZ
					
					degtorad((TopRotZ-BaseRotZ) * term + BaseRotZ)
					
					"
					HlprPosSpine.rotation.controller.Z_rotation.controller = RotScript
				)
				
				print u
				u += 100.0/(Nbones-1)
			)
			
			--Create Orientation Helper--
			
			u=0.0
			
			for i in 1 to Nbones by 1 do
			(
				local HlprPosSpine = getNodeByName((SetupCharacterName + "_Hlpr_Spine_Pos_" + i as string)) 
				--execute("$Biped_Hlpr_Spine_Pos_" + i as string)
				
				local HlprRotSpine = Point name:(SetupCharacterName + "_Hlpr_Spine_Rot_" + i as string) size:10 wirecolor:[255,150,255] box:on centermarker:off axistripod:off cross:off
				
				local posCnst = Position_constraint ()
				posCnst.appendtarget HlprPosSpine 100
				HlprRotSpine.position.controller = posCnst
				
				if i < Nbones then
				(
					local HlprPosSpineNext = getNodeByName((SetupCharacterName + "_Hlpr_Spine_Pos_" + (i+1) as string))
					--execute("$Biped_Hlpr_Spine_Pos_" + (i+1) as string)
					local LookAtCnst = lookat_constraint ()
					LookAtCnst.appendtarget HlprPosSpineNext 100
					LookAtCnst.target_axis = 2
					LookAtCnst.upnode_axis = 1
					LookAtCnst.StoUP_axis = 1
					LookAtCnst.upnode_world = false
					if i == 1 then
					(
						LookAtCnst.pickUpNode = Hip
					)
					else
					(
						LookAtCnst.pickUpNode = HlprPosSpine
					)
					
					HlprRotSpine.rotation.controller = LookAtCnst
					
					
				)
				else
				(
					HlprRotSpine.parent = Chest
				)
				
				
				print u
				u += 100.0/(Nbones-1)
			)
			
			----Generate Spine Options
			
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
			
			custattributes.add SpineOption.modifiers[1] SpineOptionModifier
			SpineCtrl = SpineOption.modifiers[1].SpineAtt
			
			--------Generate Scale helper
			
			Local SpineCurveLength = curvelength(CurveSetup)
			
			u=0.0
			
			for i in 1 to Nbones by 1 do
			(
				local HlprPosSpine =  getNodeByName((SetupCharacterName + "_Hlpr_Spine_Pos_" + i as string))
				--execute("$Biped_Hlpr_Spine_Pos_" + i as string)
				
				local HlprSclSpine = Point name:(SetupCharacterName + "_Hlpr_Spine_Scl_" + i as string) size:10 wirecolor:[255,150,255] box:off centermarker:off axistripod:on cross:off
				
				local posCnst = Position_constraint ()
				posCnst.appendtarget HlprPosSpine 100
				HlprSclSpine.position.controller = posCnst
				
				if i > (NBones/2) then 
				(
					term = 100-u
				)
				else
				(
					term = u
				)
				
				local SclScript = scale_Script ()
				SclScript.addNode "Curve" CurveSetup
				SclScript.AddConstant "baseLength" SpineCurveLength
				SclScript.AddConstant "minLength" .1
				SclScript.AddConstant "maxLength" 3
				sclScript.AddConstant "MaxSquash" 9
				sclScript.AddConstant "MinSquash" .2
				sclScript.AddConstant "term" ((term/100)*2)
				SclScript.AddTarget "Stretch" SpineCtrl[2]
				SclScript.AddTarget "Squash" SpineCtrl[3]
				SclScript.setexpression  "
	CurrentLength = curvelength(Curve)
	
	BaseLengthMin = baseLength * minlength
	BaseLengthMax = baseLength * maxlength
	
	FactorMin = ( 1 - ((CurrentLength - BaseLengthMin)/(baseLength - BaseLengthMin))  )
	FactorMax = (CurrentLength - baseLength)/(baseLengthMax - BaseLength)
	
	Rslt = If CurrentLength < baseLength then
	(
	If CurrentLength > BaseLengthMin then
	(
	1 + ((MaxSquash - 1) * FactorMin) * term
	)
	else
	(
	1 + (MaxSquash - 1) * term
	)
	
	)
	else
	(
	If CurrentLength < BaseLengthMax then
	(
	1 - (MinSquash * FactorMax) * term
	)
	else
	(
	1 - MinSquash * term
	)
	)
	
	If Stretch == 1 then
	(
	if Squash == 1 then
	(
	[Rslt,Rslt,1.0]
	)
	else
	(
	[1.0,1.0,1.0]
	)
	)
	else
	(
	[1.0,1.0,1.0]
	)
	"
			HlprSclSpine.scale.controller = SclScript
				
				
				print u
				u += 100.0/(Nbones-1)
			)
			
			
			--------CTRL FK
			
			
			for i in 1 to Nbones by 1 do
			(
				
				local HlprRotSpine =  getNodeByName((SetupCharacterName + "_Hlpr_Spine_Rot_" + i as string))
				--execute("$Biped_Hlpr_Spine_Rot_" + i as string)
				CtrlFKSpine = point name:(SetupCharacterName + "_Ctrl_Spine_FK_" + i as string) size:40 wirecolor:[255,0,255] Box:on axistripod:off centermarker:off cross:off
				CtrlFKSpine.transform = HlprRotSpine.transform
				
				If i == 1 then
				(
					CtrlFKSpine.parent = Hip
				)
				else
				(
					local CtrlFKSpineParent =  getNodeByName((SetupCharacterName + "_Ctrl_Spine_FK_" + (i-1) as string))
				--execute("$Biped_Ctrl_Spine_FK_" + (i-1) as string)
					CtrlFKSpine.parent = CtrlFKSpineParent
				)
				
				
			)
			
			
			-------/////////////RSLT//////////////
			
			for i in 1 to Nbones by 1 do
			(
				HlprPosSpine =  getNodeByName((SetupCharacterName + "_Hlpr_Spine_Pos_" + i as string))
				--execute ("$Biped_Hlpr_Spine_Pos_" + i as string)
				HlprRotSpine =  getNodeByName((SetupCharacterName + "_Hlpr_Spine_Rot_" + i as string))
				--execute ("$Biped_Hlpr_Spine_Rot_" + i as string)
				HlprSclSpine =  getNodeByName((SetupCharacterName + "_Hlpr_Spine_Scl_" + i as string))
				--execute ("$Biped_Hlpr_Spine_Scl_" + i as string)
				CtrlFkSpine=  getNodeByName((SetupCharacterName + "_Ctrl_Spine_FK_" + i as string))
				--execute ("$Biped_Ctrl_Spine_FK_" + i as string)
				
				RsltSpine = point name:(SetupCharacterName + "_Rslt_Spine_" + i as string) size:5 wirecolor:[255,128,0] Box:on axistripod:off centermarker:off cross:off
				
				--Position
				
				If i == 1 then
				(
					PosScrpt = Position_Script ()
					PosScrpt.addnode "Fk" CtrlFkSpine
					PosScrpt.addnode "IK" HlprPosSpine
					PosScrpt.addtarget "Switch" SpineCtrl[1]
					PosScrpt.setexpression "
					
					Fkpos = Fk.position
					Ikpos = IK.position
					
					(FKpos - IKpos) * Switch + IKpos
					
					"
				)
				else
				(
					LastResultSpine =  getNodeByName((SetupCharacterName + "_Rslt_Spine_" + (i-1) as string))
					--execute("$Biped_Rslt_Spine_" + (i-1) as string)
	
					PosScrpt = Position_Script ()
					PosScrpt.addnode "Fk" CtrlFkSpine
					PosScrpt.addnode "IK" HlprPosSpine
					PosScrpt.addtarget "Switch" SpineCtrl[1]
					PosScrpt.addnode "ParentResult" LastResultSpine
					PosScrpt.addConstant "FracLength" (SpineCurveLength/(Nbones-1))
					PosScrpt.addtarget "Stretch" SpineCtrl[2]	
					PosScrpt.setexpression"
	
						PositionIKUnstretch = (normalize(IK.position - ParentResult.position) * FracLength) + ParentResult.position
						PositionIKstretch = IK.position
						
						If stretch ==1 then
						(
						 IKpos = PositionIKstretch
						)
						else
						(
						 IKpos = PositionIKUnstretch 
						)
						
						Fkpos = FK.position
						
						(FKpos - IKpos) * Switch + IKpos
						
						"
					
				)
				
				RsltSpine.position.controller = PosScrpt
				
				--Orientation
				
				OrCnst = Orientation_Constraint()
				OrCnst.appendTarget CtrlFkSpine 100
				OrCnst.appendTarget HlprRotSpine 100
				
				FltScript1 = float_script ()
				FltScript1.addtarget "switch" SpineCtrl[1]
				FltScript1.setExpression "switch*100"
				OrCnst[1].controller = FltScript1
				
				FltScript2 = float_script ()
				FltScript2.addtarget "switch" SpineCtrl[1]
				FltScript2.setExpression "(1-switch)*100"
				OrCnst[2].controller = FltScript2
				
				RsltSpine.rotation.controller = OrCnst
				
				
				SclScrpt = Scale_Script ()
				SclScrpt.addnode "Fk" CtrlFkSpine
				SclScrpt.addnode "IK" HlprSclSpine
				SclScrpt.addtarget "Switch" SpineCtrl[1]
				SclScrpt.setExpression"
				
				Ikscl = IK.scale
				Fkscl = FK.scale
				
				(Fkscl - Ikscl) * Switch + Ikscl
				
				"
				RsltSpine.scale.controller = SclScrpt
			)
			
		)
	)
)
	
	

