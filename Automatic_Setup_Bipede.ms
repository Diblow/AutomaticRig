rollout AutomaticSetup "Guide creator" width:344 height:485
(
	--GUI
	
	label 'labelCharacterName' "Enter the name of your character:" pos:[92,4] width:165 height:13 align:#left
	edittext 'inputCharacterName' "" pos:[89,22] width:165 height:17 fieldwidth:150 align:#left
	label 'labelSep' "" pos:[81,47] width:0 height:13 align:#left
	GroupBox 'grpSpine' "Choose Spine Positions" pos:[3,49] width:336 height:79 align:#left
	colorPicker 'spineGuideColor' "" pos:[150,94] width:33 height:27 color:[64,226,213] align:#left

	button 'btnCreateHipGuide' "Hip" pos:[21,64] width:80 height:21 enabled:false align:#left
	button 'btnCreateChestDepthGuide' "Chest Depth" pos:[26,96] width:101 height:21 enabled:false align:#left 

	button 'btnCreateChestGuide' "Chest" pos:[212,96] width:80 height:21 enabled:false align:#left
	button 'btnCreateBaseGuide' "Base" pos:[128,64] width:80 height:21 enabled:false align:#left
	button 'btnCreateBaseDepthGuide' "Base Depth" pos:[226,64] width:99 height:21 enabled:false align:#left
	
	colorPicker 'leftArmGuideColor' "" pos:[82,191] width:33 height:27 color:[126,184,75] align:#left
	label 'labelColorLeftArm' "Left Color:" pos:[24,198] width:55 height:13 align:#left
	label 'labelColorRightArm' "Right Color" pos:[200,202] width:55 height:13 align:#left
	colorPicker 'rightArmGuideColor' "" pos:[259,192] width:33 height:27 color:[198,20,7] align:#left
	GroupBox 'grpArm' "Choose Left Arm Positions" pos:[3,133] width:336 height:92 align:#left
	button 'btnCreateShoulderGuide' "Shoulder  L" pos:[9,157] width:99 height:21 enabled:false align:#left
	button 'btnCreateElbowGuide' "Elbow  L" pos:[128,157] width:80 height:21 enabled:false align:#left
	button 'btnCreateWristGuide' "Wrist  L" pos:[236,157] width:80 height:21 enabled:false align:#left
	
	colorPicker 'leftLegGuideColor' "" pos:[83,293] width:33 height:27 color:[126,184,75] align:#left
	label 'labelColorLeftLeg' "Left Color:" pos:[25,300] width:55 height:13 align:#left
	label 'labelColorRightLeg' "Right Color" pos:[201,304] width:55 height:13 align:#left
	colorPicker 'RightLegGuideColor' "" pos:[260,294] width:33 height:27 color:[198,20,7] align:#left
	GroupBox 'grpLeg' "Choose Left Leg Positions" pos:[3,235] width:336 height:92 align:#left
	button 'btnCreateLeftThigh' "Thigh  L" pos:[21,259] width:80 height:21 enabled:false align:#left
	button 'btnCreateLeftKnee' "Knee  L" pos:[129,260] width:80 height:21 enabled:false align:#left
	button 'btnCreateLeftAnkle' "Ankle  L" pos:[237,259] width:80 height:21 enabled:false align:#left
	
	label 'labelInfo' "Make sure you placed your points on every axis before doing it !" pos:[21,365] width:307 height:13 align:#left
	button 'btnArmSymmetry' "Create Arm Symmetry" pos:[25,389] width:120 height:21 enabled:false align:#left
	GroupBox 'grpSymmetry' "Create Symmetry" pos:[4,341] width:336 height:92 align:#left
	button 'btnLegSymmetry' "Create Leg Symmetry" pos:[197,389] width:120 height:21 enabled:false align:#left
	
	fn CreateGuide ctrlName boneColor buttonName buttonText snapToZero = 
	(			
		viewport.setLayout #layout_1
		currentViewport = viewport.activeViewport
		viewport.setType #view_front 
		
		autorigWindow.visible = false
		
		existingObj = getNodeByName(ctrlName)
		
		local createPos = pickPoint prompt: ("Pick pos for " + ctrlName) snap:#2D
		
		if (existingObj == undefined) then
		(
			point pos:createPos name:ctrlName wirecolor:boneColor centermark:off axistripod:off cross:on box:on size:10
			buttonName.text = (buttonText + " OK ")

		)
		else
		(
			existingObj.wireColor = boneColor
			existingObj.position = createPos
		)
		
		if snapToZero == true then
		(
			
			(getNodeByName(ctrlName)).position.x = 0
		)
		
		autorigWindow.visible = true
	)
	
	fn CreateSymmetry ctrlNameL ctrlNameR boneColor= 
	(			
		objLeft = getNodeByName(ctrlNameL)
		local inversePos = [-1,1,1]
		existingObj = getNodeByName(ctrlNameR)
		
		if objLeft != undefined then
		(
			if (existingObj == undefined) then
			(
				point pos:(objLeft.position*inversePos) name:ctrlNameR wirecolor:boneColor centermark:off axistripod:off cross:on box:on size:10
			)
			else
			(
				existingObj.wireColor = boneColor
				existingObj.position = objLeft.position*inversePos
			)
			
		)
	)
	
	fn ColorChanging ctrlNameNew ctrlNameColor=
	(
		objNewColor = getNodeByName(ctrlNameNew)
		if objNewColor != undefined 
		then
		(
			objNewColor.wirecolor = ctrlNameColor
		)
	)

	on AutomaticSetup open do
	(
		inputCharacterName.text = SetupCharacterName
	)
	
	on inputCharacterName changed str do
	(
		if (inputCharacterName.text == "")
		then
		(
			btnCreateHipGuide.enabled = false
			btnCreateChestDepthGuide.enabled = false
			btnCreateChestGuide.enabled = false
			btnCreateBaseGuide.enabled = false
			btnCreateBaseDepthGuide.enabled = false
			btnCreateShoulderGuide.enabled = false
			btnCreateElbowGuide.enabled = false
			btnCreateWristGuide.enabled = false
			btnCreateShoulderGuide.enabled = false
			btnCreateLeftThigh.enabled = false
			btnCreateLeftKnee.enabled = false
			btnCreateLeftAnkle.enabled = false
			btnArmSymmetry.enabled = false
			btnLegSymmetry.enabled = false
		)
		else
		(
			btnCreateHipGuide.enabled = true
			btnCreateChestDepthGuide.enabled = true
			btnCreateChestGuide.enabled = true
			btnCreateBaseGuide.enabled = true
			btnCreateBaseDepthGuide.enabled = true
			btnCreateElbowGuide.enabled = true
			btnCreateWristGuide.enabled = true
			btnCreateShoulderGuide.enabled = true
			btnCreateLeftThigh.enabled = true
			btnCreateLeftKnee.enabled = true
			btnCreateLeftAnkle.enabled = true
			btnArmSymmetry.enabled = true
			btnLegSymmetry.enabled = true
		)
		
		SetupCharacterName = inputCharacterName.text
	)
	on spineGuideColor changed color do
	(
		ColorChanging (SetupCharacterName + "_Guide_Hip") spineGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Chest") spineGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_ChestDepth") spineGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Base") spineGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_BaseDepth") spineGuideColor.color
	)
	on btnCreateHipGuide pressed do
	(
		CreateGuide (SetupCharacterName + "_Guide_Hip") spineGuideColor.color btnCreateHipGuide ("Hip: ") true
	)
	on btnCreateChestDepthGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_ChestDepth") spineGuideColor.color btnCreateChestDepthGuide ("ChestDepth: ") true
	)
	on btnCreateChestGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Chest") spineGuideColor.color btnCreateChestGuide ("Chest: ") true
	)
	on btnCreateBaseGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Base") spineGuideColor.color btnCreateBaseGuide ("Base: ") true
	)
	on btnCreateBaseDepthGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_BaseDepth") spineGuideColor.color btnCreateBaseDepthGuide ("BaseDepth: ") true
	)
	on leftArmGuideColor changed color do
	(
		ColorChanging (SetupCharacterName + "_Guide_Shoulder_L") leftArmGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Elbow_L") leftArmGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Wrist_L") leftArmGuideColor.color
	)
	on rightArmGuideColor changed color do
	(
		ColorChanging (SetupCharacterName + "_Guide_Shoulder_R") rightArmGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Elbow_R") rightArmGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Wrist_R") rightArmGuideColor.color
	)
	on btnCreateShoulderGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Shoulder_L") leftArmGuideColor.color btnCreateShoulderGuide ("Shoulder_L: ") false
	)
	on btnCreateElbowGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Elbow_L") leftArmGuideColor.color btnCreateElbowGuide ("Elbow_L: ") false
	)
	on btnCreateWristGuide pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Wrist_L") leftArmGuideColor.color btnCreateWristGuide ("Wrist_L: ") false
	)
	on leftLegGuideColor changed color do
	(
		ColorChanging (SetupCharacterName + "_Guide_Thigh_L") leftLegGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Knee_L") leftLegGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Ankle_L") leftLegGuideColor.color
	)
	on RightLegGuideColor changed color do
	(
		ColorChanging (SetupCharacterName + "_Guide_Thigh_R") rightLegGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Knee_R") rightLegGuideColor.color
		ColorChanging (SetupCharacterName + "_Guide_Ankle_R") rightLegGuideColor.color
	)
	on btnCreateLeftThigh pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Thigh_L") leftLegGuideColor.color btnCreateLeftThigh ("Thigh_L: ") false
	)
	on btnCreateLeftKnee pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Knee_L") leftLegGuideColor.color btnCreateLeftKnee ("Knee_L: ") false
	)
	on btnCreateLeftAnkle pressed do
	(
		CreateGuide(SetupCharacterName + "_Guide_Ankle_L") leftLegGuideColor.color btnCreateLeftAnkle ("Ankle_L: ") false
	)
	on btnArmSymmetry pressed do
	(
		CreateSymmetry(SetupCharacterName + "_Guide_Shoulder_L")(SetupCharacterName + "_Guide_Shoulder_R") rightArmGuideColor.color
		CreateSymmetry(SetupCharacterName + "_Guide_Elbow_L")(SetupCharacterName + "_Guide_Elbow_R") rightArmGuideColor.color
		CreateSymmetry(SetupCharacterName + "_Guide_Wrist_L")(SetupCharacterName + "_Guide_Wrist_R") rightArmGuideColor.color
	)
	on btnLegSymmetry pressed do
	(
		CreateSymmetry(SetupCharacterName + "_Guide_Thigh_L")(SetupCharacterName + "_Guide_Thigh_R") rightLegGuideColor.color
		CreateSymmetry(SetupCharacterName + "_Guide_Knee_L")(SetupCharacterName + "_Guide_Knee_R") rightLegGuideColor.color
		CreateSymmetry(SetupCharacterName + "_Guide_Ankle_L")(SetupCharacterName + "_Guide_Ankle_R") rightLegGuideColor.color
	)
)


if (autorigWindow == undefined) then
(
	global autorigWindow = newRolloutFloater "Autorig" 360 640 
)
else if (autorigWindow.open == false) then
(
	closeRolloutFloater autorigWindow
	global autorigWindow = newRolloutFloater "Autorig" 360 640
)

autorigWindow.visible = true

global SetupCharacterName


filein "SpineSolver_Automatic.ms"

addRollout AutomaticSetup autorigWindow 
addRollout CreateSpine autorigWindow 














