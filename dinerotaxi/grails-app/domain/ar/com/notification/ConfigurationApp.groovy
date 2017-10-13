
package ar.com.notification;


class ConfigurationApp {
	String googleApiKey
	String app
	String mapKey
	String mailkey
	String mailSecret
	String mailFrom
	String androidAccountType
	String androidEmail
	String androidPass
	String androidToken
	String appleIp
	Integer applePort
	String appleCertificatePath
	String applePassword
	String androidUrl= 'test'
	String iosUrl= 'test'
	String windowsPhoneUrl= 'test'
	String bb10Url= 'test'
	String pageTitle= 'test'
	String pageCompanyTitle= 'test'
	String pageCompanyDescription= 'test'
	String pageCompanyStreet= 'test'
	String pageCompanyZipCode= 'test'
	String pageCompanyState= 'test'
	String pageCompanyLinkedin= 'test'
	String pageCompanyFacebook= 'test'
	String pageCompanyTwitter= 'test'
	String pageCompanyWeb
	String pageCompanyLogo
	String currency ='$'
	Integer intervalPoolingTripInTransaction =20
	Integer intervalPoolingTrip=20
	Integer timeDelayTrip=10
	Float  distanceSearchTrip=2
	Float percentageSearchRatio=2
	boolean isQueueTripActivated = false
	String queueTripType = QUEUETRIPTYPE.FIRST_TAKE
	Integer disputeTimeTrip=0

	Integer driverSearchTrip=5
	boolean parking=false
	boolean parkingPolygon=false
	Integer parkingDistanceDriver=100
	Integer parkingDistanceTrip=100

	boolean hasDriverPayment=false
	//0 $ 1 %
	Integer driverPayment=0
	//0 mensual 1 quicena 2 semana 3 diario
	Integer driverTypePayment=0
	//monto
	Double  driverAmountPayment=0d
	//cargo que se le paga al driver por un viaje enterprise
	Double  driverCorporateCharge=100d

	boolean digitalRadio=true
	boolean hasRequiredZone=false
	boolean hasRequiredKm  =false
	boolean hasMobilePayment=false
	boolean paypal=false
	boolean hadUserNumber=false
	boolean endlessDispatch=false
	boolean useAdminCode = false
	String merchantId=""
	String mobileCurrency=""

	boolean hasZoneActive=false
	//0 per km 1 per zone
	Integer costRute=0
	Double costRutePerKm=0d
	Double costRutePerKmMin=0d

	boolean sendNotification
	boolean isEnable
	String zoho= 'test'
	boolean newOpshowAddressFrom=false
	boolean newOpshowAddressTo=false
	boolean newOpshowCorporate=false
	boolean newOpshowUserName=false
	boolean newOpshowUserPhone=false
	boolean newOpshowOptions=false
	boolean newOpComment=false

	boolean driverCancelTrip=false
	boolean isChatEnabled=false
	boolean passengerDispatchMultipleTrips=false
	boolean operatorDispatchMultipleTrips=false
	boolean operatorSuggestDestination=false
	boolean operatorCancelationReason=false
	boolean driverCancellationReason=false
	boolean blockMultipleTrips=false

	boolean hasDriverDispatcherFunction=false
	boolean driverShowScheduleTrips=true


	boolean isFareCalculatorActive=false

	boolean creditCardEnable=false
	Double fareInitialCost=0d
	Double fareCostPerKm=0d
	//Intervalo entre puntos donde se activa el costo por tiempo
	Integer fareConfigActivateTimePerDistance=0

	Integer fareConfigGraceTime=0
	Integer fareConfigGracePeriodMeters=0
	Integer fareConfigTimeInitialSecWait=0
	Double fareCostTimeInitialSecWait=0d
	Integer fareConfigTimeSecWait=0
	Double fareCostTimeWaitPerXSeg=0d

	Boolean driversProfileEditable =true
	String distanceType

	boolean isPrePaidActive=false
	Integer driverQuota=0
	String packageCompany = 'BASIC'
	String subdomain = 'xxx.xx'
	def beforeInsert = {
		androidUrl= 'test'
		iosUrl= 'test'
		windowsPhoneUrl= 'test'
		bb10Url= 'test'
		intervalPoolingTripInTransaction =20
		intervalPoolingTrip=20
		timeDelayTrip=10
		driverSearchTrip=5
		distanceSearchTrip=2
	}
	static mapping = {
		cache true
		cache usage:'read-write'
		isPrePaidActive defaultValue: false
		driverQuota defaultValue: 10
		subdomain  defaultValue: 'xxx.xx'
		distanceType  column: "distance_type", sqlType: "char", length: 3,defaultValue: ''
		percentageSearchRatio defaultValue: 0f
		digitalRadio defaultValue: false
		hasZoneActive defaultValue: false
		hasRequiredZone defaultValue: false
		driverCancellationReason defaultValue: false
		useAdminCode defaultValue: false
		hasRequiredKm defaultValue: false
		hasMobilePayment defaultValue: false
		paypal defaultValue: false
		endlessDispatch defaultValue: false
		parking defaultValue: false
		parkingPolygon defaultValue: false
		hasDriverPayment defaultValue: false
		hadUserNumber defaultValue: false
		newOpshowAddressFrom defaultValue: false
		newOpshowAddressTo defaultValue: false
		newOpshowCorporate defaultValue: false
		newOpshowUserName defaultValue: false
		newOpshowOptions defaultValue: false
		newOpshowUserPhone defaultValue: false
		newOpComment defaultValue: false
		isChatEnabled defaultValue: false
		packageCompany defaultValue: 'BASIC'
		driverCancelTrip defaultValue:false
		driverShowScheduleTrips defaultValue:true
		passengerDispatchMultipleTrips defaultValue:false
		operatorDispatchMultipleTrips defaultValue:false
		operatorSuggestDestination defaultValue:false
		blockMultipleTrips defaultValue:false

		hasDriverDispatcherFunction defaultValue: false

		isFareCalculatorActive      defaultValue: false
		creditCardEnable  defaultValue: false
		fareInitialCost defaultValue:0d
		fareCostPerKm   defaultValue:0d
		fareConfigActivateTimePerDistance defaultValue:0
		fareConfigTimeSecWait        defaultValue:0
		fareConfigTimeInitialSecWait defaultValue:0
		fareCostTimeInitialSecWait   defaultValue:0d
		fareCostTimeWaitPerXSeg      defaultValue:0d

		driverCorporateCharge        defaultValue:100d

		merchantId defaultValue:''
		mobileCurrency defaultValue: ''
		pageTitle defaultValue: ''
		pageCompanyTitle defaultValue: ''
		pageCompanyDescription defaultValue: ''
		pageCompanyStreet defaultValue: ''
		pageCompanyZipCode defaultValue: ''
		pageCompanyState defaultValue: ''
		pageCompanyLinkedin defaultValue: ''
		pageCompanyFacebook defaultValue: ''
		pageCompanyTwitter defaultValue: ''
		distanceType defaultValue: 'KM'
		zoho defaultValue: ''
		googleApiKey defaultValue: ''
		driversProfileEditable defaultValue: true
		disputeTimeTrip  defaultValue: 0
		isQueueTripActivated defaultValue: false
		queueTripType  defaultValue: QUEUETRIPTYPE.FIRST_TAKE
	}
	static constraints = {
		app(nullable:true,blank:true)
		driversProfileEditable(nullable:true,blank:true)
		mailkey(nullable:true,blank:true)
		mailSecret(nullable:true,blank:true)
		mailFrom(nullable:true,blank:true)
		androidAccountType(nullable:true,blank:true)
		androidEmail(nullable:true,blank:true)
		androidPass(nullable:true,blank:true)
		androidToken(nullable:true,blank:true)
		appleIp(nullable:true,blank:true)
		applePort(nullable:true,blank:true)
		appleCertificatePath(nullable:true,blank:true)
		applePassword(nullable:true,blank:true)
		androidUrl(nullable:true,blank:true)
		iosUrl(nullable:true,blank:true)
		windowsPhoneUrl(nullable:true,blank:true)
		bb10Url(nullable:true,blank:true)
		pageTitle(nullable:true,blank:true)
		pageCompanyTitle(nullable:true,blank:true)
		pageCompanyDescription(nullable:true,blank:true, maxSize:65000)
		pageCompanyStreet(nullable:true,blank:true)
		pageCompanyZipCode(nullable:true,blank:true)
		pageCompanyState(nullable:true,blank:true)
		pageCompanyLinkedin(nullable:true,blank:true)
		pageCompanyFacebook(nullable:true,blank:true)
		pageCompanyTwitter(nullable:true,blank:true)
		pageCompanyWeb(nullable:true,blank:true)
		pageCompanyLogo(nullable:true,blank:true)
		currency(nullable:true,blank:true)
		zoho(nullable:true,blank:true)
		subdomain(nullable:true,blank:true)
	}
}
public enum QUEUETRIPTYPE{
	FIRST_TAKE,BEST_DISTANCE,BEST_TIME
}
