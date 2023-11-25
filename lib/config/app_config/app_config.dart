class AppConfig{
  static var httpGetHeader = {
    "Access-Control-Allow-Origin": "*",
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  static var httpImageGetHeader = {
    "Accept": "*/*",
  };

  static var httpPostHeader = {
    "Access-Control-Allow-Origin": "*",
    // "authToken": token,
    "Accept": "application/json",
    'Content-Type':'application/json',
  };
  static var httpPostHeaderForEncode = {
    "Access-Control-Allow-Origin": "*",
    // "authToken": token,
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded"
  };

}