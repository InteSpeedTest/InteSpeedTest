<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Network Speed Test</title>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
<link rel="stylesheet" href="assets/css/main.css" />
<!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
<!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
<script type="text/javascript" src="jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="jquery.ba-throttle-debounce.js"></script>
<!-- Scripts -->
<!-- <script src="assets/js/jquery.min.js"></script> -->
<script src="assets/js/jquery.scrollex.min.js"></script>
<script src="assets/js/jquery.scrolly.min.js"></script>
<script src="assets/js/skel.min.js"></script>
<script src="assets/js/util.js"></script>
<!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
<script src="assets/js/main.js"></script>
<link rel="stylesheet" type="text/css" href="assets/css/loading-bar.css" />
<script type="text/javascript" src="assets/js/loading-bar.js"></script>

<!-- Get geo information
		<script>
			$.getJSON('https://ipinfo.io', function(data) {
			console.log(data);
			$("#ip").val(data.ip);
			$("#geo").val(data.loc);
			$("#org").val(data.org);
			$("#city").val(data.city);
			})
		</script>
		 -->
<script type="text/javascript">
	function insert(){
		var src = document.getElementById("gamediv");
		var img = document.createElement("img");
		img.src = "running.gif";
		src.appendChild(img);
	}
</script>
<script>
			var lowPing = 9999;
			for(var x=0;x<3;x++){
				var element = "pingTime"+(x+1);
				var pingTime = pingInterest(element);
				setTimeout(function(){
				},200);
			}
		
			function pingInterest(element){
				var ping = new Date;

	    		$.ajax({
	     	   		url: "test.html",
	     	   		cache:false,
	     	   		success: function(output){ 
	     	   			ping = new Date - ping;
	     	       		console.log("Ping/Latency: " + ping);
	     	      		document.getElementById(element).value = ping;
	     	      		return ping;
	      	  		}
	  	  		});
			}
		</script>
<script>
		var arr1, arr2, arr3, arr4; // Store throughput for each thread
		var c5flag = 0;
		var c5trigger = 0;
		var c6flag = 0;
		var c6trigger = 0;
		var c5StartIndex = -1;
		var c6StartIndex = -1;
		var picName = "house";
		var termTime = 200;
		
		function changeTime(time){
			termTime = time*10;
		}
		//pretest();
		
		function pretest(){
			//document.getElementById("submit").value = "Pretest Running";
			arr1 = [];
			arr2 = [];

			var xhr = new XMLHttpRequest();
			var xhr2 = new XMLHttpRequest();
			
			// ignore first 30*100ms = 3s, to eliminate TCP slow start impact 
			var c1 = 0, temp1 = 0, eload1 = 0;
			var c2 = 0, temp2 = 0, eload2 = 0;
			
			var earlyFinish = 0;
			
			// finish flag for each XHR
			var finish1 = 0;
			var finish2 = 0;
			
			// overall downloading time
			var totalTime = 0;
			
			xhr.open("GET", picName+".jpg?" + new Date().getTime());
			xhr2.open("GET", picName+"2.jpg?" + new Date().getTime());
			
			
			var t0 = performance.now();
			var t1 = performance.now();
			var t2 = performance.now();
		
			xhr.onprogress = $.throttle(100, function (e) {
				c1++;
				t1 = performance.now();		
				arr1.push(((e.loaded)/1048576)/((t1)/1000));
				if(c1==32){
					console.log("Early Termination:");
					earlyFinish = 1;
					xhr.abort();
					xhr2.abort();
					calculatePreTest();
					console.log("Early Termination ends!");
				}
				
			});
			xhr2.onprogress = $.throttle(100, function (e) {
				c2++;
				t2 = performance.now();
				arr2.push(((e.loaded)/1048576)/((t2)/1000));
			});
			
			xhr.onloadstart = function (e) {
				console.log("Pretest 1 start");
			}
			xhr2.onloadstart = function (e) {
				console.log("Pretest 2 start");
			}
			
			xhr.onloadend = function (e) {
				console.log("Pretest1 ends");
				var t1 = performance.now();
				console.log("Pretest1 took " + (t1-t0) + " milliseconds.");
				finish1 = 1;
				if(finish1 == 1 && finish2 == 1 && earlyFinish == 0){
					console.log("Normal Ends:");
					calculatePreTest();
					finish1 = 0;
					console.log("Here!");
				}
			}
			xhr2.onloadend = function (e) {
				console.log("Pretest2 ends");
				var t2 = performance.now();
				console.log("Pretest 2 took " + (t2-t0) + " milliseconds.");
				finish2 = 1;
			}
			
			xhr.send();
			xhr2.send();
		}
		
		// Combine four arrays
		function calculatePreTest(){
			var arr = new Array();
			for(var i=0; i<Math.min(arr1.length, arr2.length);i++){
				arr.push(arr1[i]+arr2[i]);
			}
			//document.getElementById("arrayData").value = arr;
			console.log("Pretest Result: "+arr[arr.length-1]);
			if(arr[arr.length-1]<1.5){
				picName = "tree";
			}else if(arr[arr.length-1]>5){
				picName = "house";
			}
			console.log(picName + " Selected");
			//document.getElementById("submit").value = "Pretest Finished";
		}
		
			function changePic(picNames){
				picName = picNames;
			}
			function download(){
				insert();
				timedCount();
				document.getElementById("submit").value = "Test Processing";
				document.getElementById("startButton").disabled = "disabled";
				arr1 = [];
				arr2 = [];
				arr3 = [];
				arr4 = [];
				arr5 = [];
				arr6 = [];
				
				var xhr = new XMLHttpRequest();
				var xhr2 = new XMLHttpRequest();
				var xhr3 = new XMLHttpRequest();
				var xhr4 = new XMLHttpRequest();
				var xhr5 = new XMLHttpRequest();;
				var xhr6 = new XMLHttpRequest();;
				
				// ignore first 30*100ms = 3s, to eliminate TCP slow start impact 
				var c1 = 0, temp1 = 0, eload1 = 0;
				var c2 = 0, temp2 = 0, eload2 = 0;
				var c3 = 0, temp3 = 0, eload3 = 0;
				var c4 = 0, temp4 = 0, eload4 = 0;
				var c5 = 0, temp5 = 0, eload5 = 0;
				var c6 = 0, temp6 = 0, eload6 = 0;
				
				var a1=40,a2=40,a3=40,a4=40;
				var a5=20,a6=20;
				
				// finish flag for each XHR
				var finish1 = 0;
				var finish2 = 0;
				var finish3 = 0;
				var finish4 = 0;
				
				// overall downloading time
				var totalTime = 0;
				
				xhr.open("GET", picName+".jpg?" + new Date().getTime());
				//xhr2.open("GET", "http://christopher5106.github.io/img/mac_digits.png?" + new Date().getTime());
				
				xhr2.open("GET", picName+"2.jpg?" + new Date().getTime());
				
				xhr3.open("GET", picName+"3.jpg?" + new Date().getTime());
				xhr4.open("GET", picName+"4.jpg?" + new Date().getTime());
				//https://attach.bbs.miui.com/forum/201503/16/185602etd848yutd9uyt88.jpg  --4520KB
				//
				
				//xhr.open("GET", "http://imgsrc.baidu.com/imgad/pic/item/6f061d950a7b0208aff74ec568d9f2d3572cc8dc.jpg");
				
				var t0 = performance.now();
				var t1 = performance.now();
				var t2 = performance.now();
				var t3 = performance.now();
				var t4 = performance.now();
				var t5 = performance.now();
				var t6 = performance.now();
				var count = -1;
				
				// Start at 25Mbps
				xhr5.onprogress = $.throttle(100, function (e) {
					c5++;
					t5 = performance.now();
					
					if(c5==20){
						temp5 = t5;
						eload5 = e.loaded;
					}
					
					var tempValue = ((e.loaded-eload5)/1048576)/((t5-temp5)/1000);
					if(c5>a5){
						arr5.push(tempValue);
					}
				});
				
				// Start at 35Mbps
				xhr6.onprogress = $.throttle(100, function (e) {
					c6++;
					t6 = performance.now();
					
					if(c6==20){
						temp6 = t6;
						eload6 = e.loaded;
					}
					
					var tempValue = ((e.loaded-eload6)/1048576)/((t6-temp6)/1000);
					if(c6>a6){
						arr6.push(tempValue);
					}
				});
				
				xhr.onprogress = $.throttle(100, function (e) {
					c1++;
					t1 = performance.now();
					
					
					// 1st: wait 4 seconds to overcome slow start;
					// 2nd: if adds thread 5, then wait another 2 seconds
					// 3nd: if adds thread 6, then wait another 2 seconds
					if(c1==a1){ //a1 = 4s or current+2s (if adds more threads)
						temp1 = t1;
						eload1 = e.loaded;
					}
					
					var tempValue = ((e.loaded-eload1)/1048576)/((t1-temp1)/1000);
					
					// Check if the previous 100ms reaches threshold speed
					if(c1>40){
						if(count>=0){
							var totalTemp = arr1[count]+arr2[count]+arr3[count]+arr4[count];
							if(totalTemp>3.125 && c5flag==0){
								temp5 = performance.now();
								xhr5.open("GET", picName+"5.jpg?" + new Date().getTime());
								c5flag = 1;//run the thread only once
								c5trigger = 1;
								
								// need to recalculate, so clear the array
								a1 = c1+40;
								a2 = c2+40;
								a3 = c3+40;
								a4 = c4+40;
								arr1 = [];
								arr2 = [];
								arr3 = [];
								arr4 = [];
								arr5 = [];
								arr6 = [];
								
								console.log("c5 start");
								xhr5.send();
							}
							if(totalTemp>4.375 && c6flag==0){
								temp6 = performance.now();
								xhr6.open("GET", picName+"6.jpg?" + new Date().getTime());
								c6flag = 1;
								c6trigger = 1;

								// need to recalculate, so clear the array
								a1 = c1+40;
								a2 = c2+40;
								a3 = c3+40;
								a4 = c4+40;
								arr1 = [];
								arr2 = [];
								arr3 = [];
								arr4 = [];
								arr5 = [];
								arr6 = [];
								
								console.log("c6 start");
								xhr6.send();		
							}
						}
						count++;
					}
					
					if(c1>a1){
						arr1.push(tempValue);
					}
					
					if(c1>termTime){
						totalTime = (t1-t0)/1000.0;
						document.getElementById('totalTime').value = totalTime;
						calculate();
						if(c5>0){
							xhr5.abort();
						}
						if(c6>0){
							xhr6.abort();
						}
						xhr2.abort();
						xhr3.abort();
						xhr4.abort();
						xhr.abort();
					}
				});
				xhr2.onprogress = $.throttle(100, function (e) {
					c2++;
					t2 = performance.now();
					if(c2==a2){
						temp2 = t2;
						eload2 = e.loaded;
					}
					if(c2>a2){
						arr2.push(((e.loaded-eload2)/1048576)/((t2-temp2)/1000));
					}
				});
				xhr3.onprogress = $.throttle(100, function (e) {
					c3++;
					t3 = performance.now();
					if(c3==40){
						temp3 = t3;
						eload3 = e.loaded;
					}
					if(c3>a3){
						arr3.push(((e.loaded-eload3)/1048576)/((t3-temp3)/1000));
					}
				});
				xhr4.onprogress = $.throttle(100, function (e) {
					c4++;
					t4 = performance.now();
					if(c4==40){
						temp4 = t4;
						eload4 = e.loaded;
					}
					if(c4>a4){
						arr4.push(((e.loaded-eload4)/1048576)/((t4-temp4)/1000));
					}
				});
				xhr.onloadstart = function (e) {
					console.log("1 start");
				}
				xhr2.onloadstart = function (e) {
					console.log("2 start");
				}
				xhr3.onloadstart = function (e) {
					console.log("3 start");
				}
				xhr4.onloadstart = function (e) {
					console.log("4 start");
				}
				xhr5.onloadstart = function (e) {
					console.log("5 start");
				}
				xhr6.onloadstart = function (e) {
					console.log("6 start");
				}
				
				xhr.onloadend = function (e) {
					console.log("end");
					var t1 = performance.now();
					console.log("1 Call to doSomething took " + (t1-t0) + " milliseconds.");
					finish1 = 1;
					document.getElementById('submit').value = "File 1 Downloaded.";
					if(finish1 == 1 && finish2 == 0 && finish3 == 0 && finish4 == 0){
						totalTime = (t1-t0)/1000.0;
						//document.getElementById('totalTime').value = totalTime;
						//calculate();
						xhr2.abort();
						xhr3.abort();
						xhr4.abort();
					}
				}
				xhr2.onloadend = function (e) {
					console.log("end");
					var t2 = performance.now();
					console.log("2 Call to doSomething took " + (t2-t0) + " milliseconds.");
					finish2 = 1;
					document.getElementById('submit').value = "File 2 Downloaded.";
					if(finish1 == 0 && finish2 == 1 && finish3 == 0 && finish4 == 0){
						totalTime = (t2-t0)/1000.0;
						//document.getElementById('totalTime').value = totalTime;
						//calculate();
						xhr.abort();
						xhr3.abort();
						xhr4.abort();
					}
				}
				xhr3.onloadend = function (e) {
					console.log("end");
					var t3 = performance.now();
					console.log("3 Call to doSomething took " + (t3-t0) + " milliseconds.");
					finish3 = 1;
					document.getElementById('submit').value = "File 3 Downloaded.";
					if(finish1 == 0 && finish2 == 0 && finish3 == 1 && finish4 == 0){
						totalTime = (t3-t0)/1000.0;
						//document.getElementById('totalTime').value = totalTime;
						//calculate();
						xhr.abort();
						xhr2.abort();
						xhr4.abort();
					}
				}
				xhr4.onloadend = function (e) {
					console.log("end");
					var t4 = performance.now();
					console.log("4 Call to doSomething took " + (t4-t0) + " milliseconds.");
					finish4 = 1;
					document.getElementById('submit').value = "File 4 Downloaded.";
					if(finish1 == 0 && finish2 == 0 && finish3 == 0 && finish4 == 1){
						totalTime = (t4-t0)/1000.0;
						//document.getElementById('totalTime').value = totalTime;
						//calculate();
						xhr.abort();
						xhr2.abort();
						xhr3.abort();
				
					}
				}
				
				xhr.send();
				xhr2.send();
				xhr3.send();
				xhr4.send();
			}
			
			// Combine four arrays
			function calculate(){
				var arr = new Array();
				
				
				// ignore first 3 elements, since they are normally not accurate enough
				for(var i=3; i<Math.min(arr1.length, arr2.length, arr3.length, arr4.length);i++){
					/*
					if(i==0){
						for(var j=0;j<arr5.length;j++){
							console.log("Sum of 2:"+(arr5[j]+arr6[j])+",T1:"+arr5[j]+",T2:"+arr6[j]);
						}
					}
					*/
					// 6 Threads in total
					if(c6flag > 0){
						arr.push(arr1[i]+arr2[i]+arr3[i]+arr4[i]+arr5[i]+arr6[i]);
					}else if(c5flag > 0){ // 5 Threads in total
						arr.push(arr1[i]+arr2[i]+arr3[i]+arr4[i]+arr5[i]);
					}else{
						arr.push(arr1[i]+arr2[i]+arr3[i]+arr4[i]);
					}
					
				}
				document.getElementById("arrayData").value = arr;
				console.log(arr);
				document.getElementById("submit").click();
				document.getElementById("submit").value = "Show Result";
				//document.getElementById("submit").click();
			}
		</script>
</head>
<body>
	

	<!-- Sidebar -->
	<section id="sidebar">
	<div class="inner">
		<nav>
		<ul>
			<li><a href="#intro">Welcome</a></li>
			<li><a href="#one">Accuracy</a></li>
			<li><a href="#two">Test Flow</a></li>
			<li><a href="#three">Get in touch</a></li>
		</ul>
		</nav>
	</div>
	</section>

	<!-- Wrapper -->
	<div id="wrapper">

		<!-- Intro -->
		<section id="intro" class="wrapper style1 fullscreen fade-up">
		<div class="inner">
			<h1>Network Speed Test</h1>
			<p>Measuring your network bandwidth. Estimated processing time
				around 15 - 25 seconds or so.</p>

			<ul class="actions">
				<!-- <li><a href="javascript:download()" class="button scrolly" name="startButton" id="startButton">Start Test</a></li> -->
				<li><input type="button" id="startButton" name="startButton"
					value="Start Test" onclick="download();" /></li>
				<li><input type="hidden" id="preTestButton"
					name="pretestButton" value="Pretest" onclick="startPreTest();" /></li>
				<li><button onclick="changeTime(10)">10s</button></li>
				<li><button onclick="changeTime(12)">12s</button></li>
				<li><button onclick="changeTime(14)">14s</button></li>
				<li><button onclick="changeTime(16)">16s</button></li>
				<li><button onclick="changeTime(18)">18s</button></li>
				<li><button onclick="changeTime(20)">20s</button></li>
				<li><button onclick="changeTime(22)">22s</button></li>
				<li><button onclick="changeTime(24)">24s</button></li>
				<li><button onclick="changeTime(26)">26s</button></li>
				<li><button onclick="changeTime(28)">28s</button></li>
				<li><button onclick="changeTime(30)">30s</button></li>
				<li><div id="gamediv"></div></li>
				<li>
					<div id="gametimer"></div>
					<script type="text/javascript">
						var c = 0;
						function timedCount(){
							document.getElementById("gametimer").innerHTML = c + " s";
							c = c + 1;
							t = setTimeout("timedCount()",1000);
						}
					</script>
				</li>
				<li>
					<form action="SpeedtestFilter" method="post">
						<input type="hidden" name="totalTime" id="totalTime" /> <input
							type="hidden" name="arrayData" id="arrayData" value="" /> <input
							type="hidden" name="pretestData" id="pretestData" value="" /> <input
							type="hidden" name="pingTime1" id="pingTime1" /> <input
							type="hidden" name="pingTime2" id="pingTime2" /> <input
							type="hidden" name="pingTime3" id="pingTime3" /> <input
							type="submit" name="submit" id="submit" value="Test Not Start"
							 style="display: none"/>
							 <!--  -->
					</form>
				</li>
			</ul>
		</div>
		</section>

		<!-- One -->
		<section id="one" class="wrapper style2 spotlights"> <section>
		<a href="#" class="image"><img src="images/pic01.jpg" alt=""
			data-position="center center" /></a>
		<div class="content">
			<div class="inner">
				<h2>95+ % Precision</h2>
				<p>Determination to pursue highest precision.</p>
				<ul class="actions">
					<li><a href="#" class="button">Learn more</a></li>
				</ul>
			</div>
		</div>
		</section> <section> <a href="#" class="image"><img
			src="images/pic02.jpg" alt="" data-position="top center" /></a>
		<div class="content">
			<div class="inner">
				<h2>Time Efficiency</h2>
				<p>Elastic test running time with respect to user's network
					potential bandwidth.</p>
				<ul class="actions">
					<li><a href="#" class="button">Learn more</a></li>
				</ul>
			</div>
		</div>
		</section> <section> <a href="#" class="image"><img
			src="images/pic03.jpg" alt="" data-position="25% 25%" /></a>
		<div class="content">
			<div class="inner">
				<h2>Pithy Result</h2>
				<p>Raw average speed; Filtered average speed; Filtered average
					speed + Machine Learning</p>
				<ul class="actions">
					<li><a href="#" class="button">Learn more</a></li>
				</ul>
			</div>
		</div>
		</section> </section>
		<div class="copyrights">Rights of the template is not reserved.</div>

		<!-- Two -->
		<section id="two" class="wrapper style3 fade-up">
		<div class="inner">
			<h2>Test Flow</h2>
			<p>Test flow introduction.</p>
			<div class="features">
				<section> <span class="icon major fa-code"></span>
				<h3>Procedure 1</h3>
				<p>Good Morning.</p>
				</section>
				<section> <span class="icon major fa-lock"></span>
				<h3>Procedure 2</h3>
				<p>Good Afternoon.</p>
				</section>
				<section> <span class="icon major fa-cog"></span>
				<h3>Procedure 3</h3>
				<p>Good Night.</p>
				</section>
				<section> <span class="icon major fa-desktop"></span>
				<h3>Procedure 4</h3>
				<p>Hello World.</p>
				</section>
				<section> <span class="icon major fa-chain"></span>
				<h3>Procedure 5</h3>
				<p>Tracer.</p>
				</section>
				<section> <span class="icon major fa-diamond"></span>
				<h3>Procedure 6</h3>
				<p>Genji at your service.</p>
				</section>
			</div>
			<ul class="actions">
				<li><a href="#" class="button">Learn more</a></li>
			</ul>
		</div>
		</section>

		<!-- Three -->
		<section id="three" class="wrapper style1 fade-up">
		<div class="inner">
			<h2>Get in touch</h2>
			<p>Help us getting better.</p>
			<div class="split style1">
				<section>
				<form method="post" action="#">
					<div class="field half first">
						<label for="name">Name</label> <input type="text" name="name"
							id="name" />
					</div>
					<div class="field half">
						<label for="email">Email</label> <input type="text" name="email"
							id="email" />
					</div>
					<div class="field">
						<label for="message">Message</label>
						<textarea name="message" id="message" rows="5"></textarea>
					</div>
					<ul class="actions">
						<li><a href="" class="button submit">Send Message</a></li>
					</ul>
				</form>
				</section>
				<section>
				<ul class="contact">
					<li>
						<h3>Address</h3> <span>Zijing Road<br /> Haidian, Beijing<br />
							China
					</span>
					</li>
					<li>
						<h3>Email</h3> <a href="#">13567@qq.com</a>
					</li>
					<li>
						<h3>Phone</h3> <span>(999) 666-2333</span>
					</li>
					<li>
						<h3>Social</h3>
						<ul class="icons">
							<li><a href="#" class="fa-twitter"><span class="label">Twitter</span></a></li>
							<li><a href="#" class="fa-facebook"><span class="label">Facebook</span></a></li>
							<li><a href="#" class="fa-github"><span class="label">GitHub</span></a></li>
							<li><a href="#" class="fa-instagram"><span class="label">Instagram</span></a></li>
							<li><a href="#" class="fa-linkedin"><span class="label">LinkedIn</span></a></li>
						</ul>
					</li>
				</ul>
				</section>
			</div>
		</div>
		</section>

	</div>

	<!-- Footer -->
	<footer id="footer" class="wrapper style1-alt">
	<div class="inner">
		<ul class="menu">
			<li>&copy; Untitled. All rights reserved.</li>
			<li>No rights of templates reserved.</li>
			<li><button onclick="changePic('tree')">8M</button></li>
			<li><button onclick="changePic('house')">100M</button></li>
		</ul>
	</div>
	</footer>



</body>
</html>