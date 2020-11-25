String BEARER_TOKEN = "";

class MyHeaders {
  static Map<String, String> header() {
    var header = {'Authorization': "bearer " + BEARER_TOKEN};
    print(header);
    return header;
  }
}
