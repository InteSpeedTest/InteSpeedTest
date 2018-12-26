<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Network Speed Test</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
		<link rel="stylesheet" href="assets/css/main.css" />
		<!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
		<!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
		
		<script src="assets/js/jquery.min.js"></script>
		<script src="assets/js/jquery.scrollex.min.js"></script>
		<script src="assets/js/jquery.scrolly.min.js"></script>
		<script src="assets/js/skel.min.js"></script>
		<script src="assets/js/util.js"></script>
		<!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
		<script src="assets/js/main.js"></script>
		<script src="Chart.bundle.js"></script>
		<script src="utils.js"></script>
		<style>
			canvas{
				-moz-user-select: none;
				-webkit-user-select: none;
				-ms-user-select: none;
			}
		</style>
	</head>
	<body>
		
	<!-- Header -->
			<header id="header">
				<a href="index.html" class="title">Network Speed Test</a>
				<nav>
					<ul>
						<li><a href="http://58.205.208.77/SpeedTest">Home</a></li>
						<li class="active">Result</li> 
						<!-- <li><a href="generic.jsp" class="active">Result</a></li> -->
						<!--<li><a href="elements.html">Elements</a></li>-->
					</ul>
				</nav>
			</header>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<section id="main" class="wrapper">
						<div class="inner">
							<h2>Results</h2>
							<p>This is the result page.</p>
							<div class="features">
								<section>
									<span class="icon major fa-code"></span>
									<h3>Overall Time</h3>
									<p><%= session.getAttribute("totalTime") %> s</p>
								</section>
								<section>
									<span class="icon major fa-lock"></span>
									<h3>Overall Average Speed</h3>
									<p><%= session.getAttribute("averageSpeed") %> MB/s</p>
								</section>
								<section>
									<span class="icon major fa-cog"></span>
									<h3>Filtered Average Speed</h3>
									<p><%= session.getAttribute("filteredAverage") %> MB/s</p>
								</section>
								<section>
									<span class="icon major fa-desktop"></span>
									<h3>Filtered Average Speed + Machine Learning</h3>
									<p><%= session.getAttribute("finalAverage") %> MB/s</p>
								</section>
								<section>
									<span class="icon major fa-chain"></span>
									<h3>Highest Speed (Filtered)</h3>
									<p><%= session.getAttribute("topSpeed") %> MB/s</p>
								</section>
								<section>
									<span class="icon major fa-diamond"></span>
									<h3>Ping</h3>
									<p><%= session.getAttribute("pingTime") %> ms</p> <br>
								</section>
							</div>
							<div style="width:100%;">
										<canvas id="canvas"></canvas>
							</div>
							<ul class="actions">
								<li><a href="#" class="button">Learn more</a></li>
								<script>
									var MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
									var config = {
									type: 'line',
									data: {
										<% double[] overall = (double[]) session.getAttribute("OverallSpeed");%>
										labels: [
											<% for(int i=0;i<overall.length;i++){%>
												"<%=(i*0.1+5)%>",
											<%}%>
											],
										datasets: [{
											label: "Downloading Speed",
											backgroundColor: window.chartColors.red,
											borderColor: window.chartColors.red,
											data: [
												<% for(int i=0;i<overall.length;i++){%>
												<%=overall[i]%>,
												<%}%>
											],
											fill: false,
										}]
									},
									options: {
										responsive: true,
										title:{
											display:true,
											text:'Filtered Downloading Speed Chart'
										},
										tooltips: {
											mode: 'index',
											intersect: false,
										},
										hover: {
											mode: 'nearest',
											intersect: true
										},
										scales: {
											xAxes: [{
												gridLines: {
													display:false
												},
												display: true,
												ticks:{
													callback: function(dataLabel, index){
														return dataLabel='';
													}
												},
												scaleLabel: {
													display: true,
													labelString: 'Time (s)'
												}
											}],
											yAxes: [{
												gridLines: {
													display:false
												},
												display: true,
												scaleLabel: {
													display: true,
													labelString: 'Downloading Speed (MB/s)'
												}
											}]
										}
									}
									};

									window.onload = function() {
										var ctx = document.getElementById("canvas").getContext("2d");
										window.myLine = new Chart(ctx, config);
									};
								</script>
							</ul>
						</div>
					</section>

			</div>

		<!-- Footer -->
			<footer id="footer" class="wrapper alt">
				<div class="inner">
					<ul class="menu">
						<li>&copy; Network Speed Test. All rights reserved.</li>
					</ul>
				</div>
			</footer>
	</body>
</html>