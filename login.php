<?php
	//測試用(已登入過，重新導向頁面)
	session_start() ;
	if(isset($_SESSION["account_UID"]))
		die("請先登出!") ;

	if(isset($_POST["Name"]))
	{
		$Name = $_POST["Name"] ;
		$Password = $_POST["Password"] ;
		
		//判斷用戶名與密碼是否合法
		(strlen($Name) <= 15 And preg_match("/^\w+$/", $Name)) or die("名稱字元不合法") ;
		(strlen($Password) >= 8 And strlen($Password) <= 15 And preg_match("/^\w+$/", $Password)) or die("密碼字元不合法") ;
		
		//連接資料庫
		require_once("sqlconnect.php") ;
		
		($result = $mysqli->query("SELECT * FROM `account` WHERE `name`='$Name' And `password`='$Password'"))
			or die("Database error(" . $mysqli->errno. ")" . $mysqli->error) ;
		$row = $result->fetch_object() ;
		
		//判斷帳號是否已經註冊並啟用
		if(!$row)
		{
			$result->free() ;
			$mysqli->close() ;
			echo("
				<!DOCTYPE html>
				<html>
				<head>
					<meta charset=\"UTF-8\">
				</head>
				<body>
					<p>帳號或密碼不正確</p>
					<a href=\"register.php\">註冊</a>
				</body>
				</html>
			") ;
			exit() ;
		}
		else if(!$row->active)
		{
			$verificate_path = "http://".$_SERVER['SERVER_NAME'].pathinfo($_SERVER["PHP_SELF"])["dirname"]."/verificate?vc=".$Verification ;
			$message = "
				<!DOCTYPE html>
				<html>
				<body>
				<h1>歡迎使用 exifmap</h1>
				<p>請點擊以下連結完成註冊:<a href=\"$verificate_path\">$verificate_path</a></p>
				</body>
				</html>
			" ;
			echo($message) ;
		}
			
		//將資料存入 session
		$_SESSION["account_UID"] = $row->uid ;
		$_SESSION["account_name"] = $row->name ;
		
		$result->free() ;
		$mysqli->close() ;
		
		//header("location: ./") ;
                exit("已登入");
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
	</head>
	<body>
		<div>
			<h1>登入已有的 exifmap 帳號</h1>
			<form method="post" action="login.php">
				帳號:
				<input type="text" name="Name" size="15"><br/>
				密碼:
				<input type="password" name="Password" size="15"><br/>
				<input type="submit" value="登入"> <a href="register.php">註冊</a>
			</form>
			
		</div>
	</body>
</html>