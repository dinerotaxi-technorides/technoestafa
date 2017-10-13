
<!DOCTYPE html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>DineroTaxi Coming Soon</title>
<link rel="stylesheet" href="${resource(dir:'css/landing',file:'style.css')}" />
<link rel="stylesheet" href="${resource(dir:'css/landing',file:'bootstrap.css')}" />
<link rel="stylesheet" href="${resource(dir:'css/landing',file:'bootstrap-responsive.css')}" />
<link rel="stylesheet" href="${resource(dir:'css/landing',file:'nivo-slider.css')}" />


<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"
	type="text/javascript"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
<script type="text/javascript"	src="${resource(dir:'js/landing',file:'jquery.backgroundpos.min.js')}"></script>
<script type="text/javascript"	src="${resource(dir:'js/landing',file:'scripts.js')}"></script>
<script type="text/javascript"	src="${resource(dir:'js/landing',file:'jquery.nivo.slider.pack.js')}"></script>

</head>

<body>
	<!--Header Block-->
	<div id="hello">
		<img src="${resource(dir:'images_landing',file:'logo.png')}" alt="Company Logo" width="200"
			height="48" />
		<h3>We are currently working hard on our brand new site.</h3>
		<h1>Stay tuned!</h1>
		<h4>The revolution has begun!</h4>
	</div>

	<!--Construction area pictures-->
	<div id="container">
		<div id="clouds">
			<div id="background-buildings">
				<div id="background-vehicles">
					<div id="background-road-seal">
						<div id="lorries">
							<div id="foreground-ground">
								<div id="container-counter">
									<div id="slideshowContainer">
										<div id="slideshow">
											<img src="${resource(dir:'images_landing',file:'slide1.jpg')}" width="454" height="169"
												alt="Coming Soon: Our Awesome Web App"> <img
												src="${resource(dir:'images_landing',file:'slide2.jpg')}" width="454" height="169"
												alt="Extensive Functionality"> <img
												src="${resource(dir:'images_landing',file:'slide3a.jpg')}" width="454" height="169"
												alt="Complete with an iPhone App">
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>



	<!--Here is container with email subscription-->
	<div class="container-fluid yellow-container bg-mail">
		<div class="row-fluid">
			<div class="span12">
				<h2>Don't miss our launch!</h2>
				<p>Enter your e-mail address and be the first to know about our
					news!</p>

				<div class="input-append">
					<form action="save.php" id="subscribe-form" method="post"
						name="subscribe-form">
						<input type="email" name="email" placeholder="Enter your email"
							id="email" class="email required" />
						<button class="btn btn-inverse" id="submit" type="submit"
							value="Subscribe">Subscribe</button>
					</form>
				</div>

			</div>
		</div>
	</div>

	<!--Here is container with "What is this?" and Contact information-->
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span4">
				<h3>What is this?</h3>
				DineroTaxi is the new way to pay for your taxi. Forget about the
				cash. Use your smartphone to ask for a taxi and use it to pay for it
				as well! A few clicks and you're done. DineroTaxi will be available
				for your smartphone soon. Meanwhile, check <a
					href="http://www.technorides.com">Technorides!</a>
			</div>
			<div class="span4">
				<h3>How does it work?</h3>
				Download our app from the Google Play Store or App Store. Register
				and link your credit card with your DineroTaxi account and that's
				all. You will be able to pay for your trips with your smartphone
				anytime, anywhere! Move. Pay &amp; Keep Moving
			</div>
			<div class="span4">
				<h3>Contact us!</h3>
				<ul>
					<li>Phone: +54 9 11 6464 0019</li>
					<li>E-mail: <a href="mailto:info@technorides.com">info@technorides.com</a></li>
					<li>Copyright 2014 | DineroTaxi LLC</li>
					<li>Delaware, USA</li>
				</ul>
			</div>
		</div>


		<!-- Social Media Buttons - CSS3 - Free to Remove Unneeded -->
		<div class="social-buttons">
			<ul class="social">
				<li><a href="http://facebook.com/Technorides"><i
						class="icon-facebook-circled"></i></a></li>
				<li><a href="http://linkedin.com/"><i
						class="icon-linkedin-circled"></i></a></li>
				<li><a href="http://twitter.com/Techno_rides"><i
						class="icon-twitter-circled"></i></a></li>
			</ul>
		</div>

	</div>
</body>
</html>