haversine<-function(lat1, long1, lat2, long2){

#adapted from Chris Veness JavaScript (c) 2002-2007 
#http://www.movable-type.co.uk/ haversine.r calculates the distance traveled or
#the angle of displacement with the Haversine function

#coefficients
a<-6378 #Equatorial radius km
b<-6357 #Polar radius km
e<-sqrt(1-b^2/a^2) #eccentricity of the ellipsoid that is Earth

# conversion
TAG_LAT_RAD<-lat1*pi/180
TAG_LONG_RAD<-long1*pi/180
RECAP_LAT_RAD<-lat2*pi/180
RECAP_LONG_RAD<-long2*pi/180
dLat<-RECAP_LAT_RAD-TAG_LAT_RAD
dLong<-RECAP_LONG_RAD-TAG_LONG_RAD


#calculates dist traveled using the Haversine function from release  
#and recapture positions in radians
       
hav<-(sin((dLat)/2))^2+
(cos(TAG_LAT_RAD)*cos(RECAP_LAT_RAD)*(sin((dLong)/2))^2)
dist_travel_rad<-2*atan2(sqrt(hav),sqrt(1-hav))  #ie half the versed  sine...the haversine formula
#distance traveled conversion, ie multplying by R with autocorrelating  R by latitude
DIST_TRAVEL_KM<-dist_travel_rad*(a*(1-e^2))/(1-
e^2*(sin(mean(c(TAG_LAT_RAD, RECAP_LAT_RAD)))^2)^(3/2))# define new  vector

# calculation of angular displacement
y<-sin(dLong)*cos(RECAP_LAT_RAD)
x<-cos(TAG_LAT_RAD)*sin(RECAP_LAT_RAD)-
sin(TAG_LAT_RAD)*cos(RECAP_LAT_RAD)*cos(dLong)
PHI_RAD<-2*pi-atan2(y,x)
PHI_DEG<-((PHI_RAD*180.0/pi)+360.0)%%360.0
#output
S<-list()
S$Dist_km<-DIST_TRAVEL_KM # distance traveled in Km
S$PHI_DEG<-PHI_DEG # Angular displacement from North in deg.
S
} 