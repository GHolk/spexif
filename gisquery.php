<?php
	if(isset($_GET["Type"]))
	{
		//檢查使用者有無登入
		require_once("logincheck.php") ;
		
		//連接資料庫
		require_once("sqlconnect.php") ;
		
		$AID = $_SESSION["account_UID"] ;
		$uploaddir = "./uploadimages/" . $AID . "/" ;
		
		if($_GET["Type"]=="Distance")
		{//查詢距離
			$Lon = $_GET["Lon"] ;
			$Lat = $_GET["Lat"] ;
			$Dist = $_GET["Dist"] ;
	
			if(!preg_match("/^\d{1,3}(\.\d{1,6})?$/", $Lon) || 
			!preg_match("/^\d{1,2}(\.\d{1,6})?$/", $Lat) ||
			!preg_match("/^\d{1,5}(\.\d{1,3})?$/", $Dist))
			{
				$mysqli->close() ;
				die("距離參數格式錯誤") ;
			}	
			
			$result = $mysqli->query("
			SELECT *
			FROM image
			WHERE `aid`='$AID' && 2*6378*ASIN(SQRT(POWER(SIN(($Lat-Y(`pos`))*pi()/180/2),2)+COS($Lat*pi()/180)*COS(Y(`pos`)*pi()/180)*POWER(SIN(($Lon-X(`pos`))*pi()/180/2),2))) < $Dist
			") ;
		}
		else if($_GET["Type"]=="Time")
		{//查詢日期
			if((!preg_match("/^\d{4}-\d{2}-\d{2}$/", $_GET["DateFrom"]) && !preg_match("/^\d{4}-\d{2}-\d{2}$/", $_GET["DateTo"])))
			{
				$mysqli->close() ;
				die("日期格式錯誤") ;
			}	
			
			$bFrom = !empty($_GET["DateFrom"]) ;
			$bTo = !empty($_GET["DateTo"]) ;
			
			$DateTimeFrom = $_GET["DateFrom"]." "."00:00:00" ;
			$DateTimeTo = $_GET["DateTo"]." "."00:00:00" ;
			
			$SQL = "SELECT * FROM image WHERE `aid`='$AID' && " ;
			if($bFrom && $bTo)
				$SQL .= "'$DateTimeFrom'<=`original_time` && `original_time`<='$DateTimeTo'" ;
			else if($bFrom)
				$SQL .= "'$DateTimeFrom'<=`original_time`" ;
			else if($bTo)
				$SQL .= "`original_time`<='$DateTimeTo'" ;
			
			$result = $mysqli->query($SQL) ;
		}
		else if($_GET["Type"]=="LLRange")
		{
			$LonFrom = $_GET["LonFrom"] ;
			$LonTo = $_GET["LonTo"] ;
			$LatFrom = $_GET["LatFrom"] ;
			$LatTo = $_GET["LatTo"] ;
			
			if(!preg_match("/^\d{1,3}(\.\d{1,6})?$/", $LonFrom) || 
			!preg_match("/^\d{1,3}(\.\d{1,6})?$/", $LonTo) ||
			!preg_match("/^\d{1,2}(\.\d{1,6})?$/", $LatFrom) ||
			!preg_match("/^\d{1,2}(\.\d{1,6})?$/", $LatTo))
			{
				$mysqli->close() ;
				die("經緯度參數格式錯誤") ;
			}
			
			$result = $mysqli->query("
			SELECT *
			FROM image
			WHERE `aid`='$AID' && $LonFrom<=X(`pos`) && X(`pos`)<=$LonTo && $LatFrom<=Y(`pos`) && Y(`pos`)<=$LatTo
			") ;
		}
		
		//寫成字串
		if($result)
		{
			echo("
				<html>
				<head>
				<meta charset=\"UTF-8\">
				</head>
				<body>
			") ;
			while($row = $result->fetch_object())
			{
				$resultFiles = $uploaddir.$row->file_name ;
				echo("<img src=\"$resultFiles\">") ;
			}
			$result->free() ;
			
			echo("
				</body>
				</html>
			") ;
		}
		else
			die("查無資料") ;
		
		$mysqli->close() ;
		exit() ;
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<script>
			function changeSQLParam(index)
			{
				if(index == 1)
				{
					document.getElementById("SQLParam").innerHTML = 
					"經度:<br/>" + 
					"<input type=\"text\" name=\"Lon\" size=\"10\">度<br/>" + 
					"緯度:<br/>" + 
					"<input type=\"text\" name=\"Lat\" size=\"9\">度<br/>" + 
					"距離:<br/>" + 
					"<input type=\"text\" name=\"Dist\" size=\"9\">公里";
				}
				else if(index == 2)
				{
					document.getElementById("SQLParam").innerHTML = 
					"開始時間:<br/>" + 
					"<input type=\"date\" name=\"DateFrom\"><br/>" +
					"結束時間:<br/>" + 
					"<input type=\"date\" name=\"DateTo\">" ;
				}
				else if(index == 3)
				{
					document.getElementById("SQLParam").innerHTML = 
					"開始經度:<br/>" + 
					"<input type=\"text\" name=\"LonFrom\" size=\"10\">度<br/>" +
					"結束經度:<br/>" + 
					"<input type=\"text\" name=\"LonTo\" size=\"10\">度<br/>" + 					
					"開始緯度:<br/>" + 
					"<input type=\"text\" name=\"LatFrom\" size=\"9\">度<br/>" + 
					"結束緯度:<br/>" + 
					"<input type=\"text\" name=\"LatTo\" size=\"9\">度<br/>" ;
				}
			}
		</script>
	</head>
	<body>
		<div>
			<h1>GIS 查詢</h1>
			<form name="m_Form" method="get" action="gisquery.php">
				類型:
				<select onChange="changeSQLParam(this.selectedIndex)" name="Type">
					<option value="">請選擇
					<option value="Distance">距離查詢
					<option value="Time">日期查詢
					<option value="LLRange">經緯度範圍查詢
				</select>
				<div id="SQLParam">
				</div>
				<input type="submit" value="查詢">
			</form>
		</div>
	</body>
</html>