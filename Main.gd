extends Control

var savePath = "user://Accounts.json"
var file = File.new()
var login_attempt = 0
var allowed_attempt = 3

var Accounts = {
	"Users": [],
	"Pass": []
}

var min_length = 6

func _ready():
	$CreateAccountBtn.connect("pressed", self, "_on_Create_Account_pressed")
	$LoginBtn.connect("pressed", self, "_on_Login_pressed")
	$Register/RegisterBtn.connect("pressed", self, "_on_Register_attempt")
	$Login/LoginBtn.connect("pressed",self, "_on_Login_attempt")
	$Message.text = ''
	
func _on_Create_Account_pressed():
	$Login.visible = false
	$Register.visible = true
	$CreateAccountBtn.visible = false
	$LoginBtn.visible = true
	$Login/LoginBtn.visible = false
	$Register/RegisterBtn.visible = true
	
func _on_Register_attempt():
	create_account()
	
func _on_Login_pressed():
	$Register.visible = false
	$Login.visible = true
	$CreateAccountBtn.visible = true
	$LoginBtn.visible = false
	$Register/RegisterBtn.visible = false
	$Login/LoginBtn.visible = true

func _on_Login_attempt():
	load_data()
	login()

func create_account():
	if $Register/Newuser.text in Accounts.values()[0]:
		$Message.text = "Username not available"
	else:
		if $Register/NewPass.text.length() >= min_length:
			Accounts.Users.append($Register/Newuser.text)
			Accounts.Pass.append($Register/NewPass.text.sha256_text())
			$Message.text = 'Account is created successfully'
			save_data()
		else: 
			$Message.text = 'Password must be %s characters long' %min_length
		

func login():
	if login_attempt < allowed_attempt:
		login_attempt+= 1
		if $Login/Username.text in Accounts.values()[0]:
			var userIndex = Accounts.Users.find($Login/Username.text)
			if Accounts.Pass[userIndex] == $Login/Password.text.sha256_text():
				$Message.text = "Logged in successfully"
				print('Logged in successfully')
			else:
				$Message.text = "Password incorrect"
				print('Password incorrect.')
		else:
			$Message.text = "no user is found"
	else:
		$Message.text = "Your login attempt has exceeded the %s" %allowed_attempt


func save_data():
	file.open(savePath, file.WRITE)
	file.store_line(to_json(Accounts))
	file.close()
	print(OS.get_user_data_dir())
	
func load_data():
	if file.file_exists(savePath):
		file.open(savePath, file.READ)
		var tmp_data = file.get_as_text()
		var parsed_data = {}
		parsed_data = parse_json(tmp_data)
		Accounts.Users = parsed_data["Users"]
		Accounts.Pass = parsed_data["Pass"]
		
		
