



import 'package:flutter_app_tv/api/api_config.dart';
import 'package:http/http.dart' as http;

class apiRest{
  static  configUrl(String url) async{
    var response;
    Uri uri = Uri.http(apiConfig.api_url.replaceAll("https://", "").replaceAll("/api/", ""), "unencodedPath");
    try{
      if(apiConfig.api_url.contains("https"))
        uri = Uri.https(apiConfig.api_url.replaceAll("https://", "").replaceAll("/api/", ""),"/api"+  url +apiConfig.api_token+"/"+apiConfig.item_purchase_code +"/");
      else
        uri=  Uri.http(apiConfig.api_url.replaceAll("http://", "").replaceAll("/api/", ""),  "/api"+url +apiConfig.api_token+"/"+apiConfig.item_purchase_code +"/");
      response  = await http.get(uri);
    }catch(ex){
      response = null;
      print(ex);
    }
    print(uri);
    return  response;
  }
  static  configPost(String url,var data) async{
    var response;
    Uri uri = Uri.http(apiConfig.api_url.replaceAll("https://", "").replaceAll("/api/", ""), "unencodedPath");
    try{
      if(apiConfig.api_url.contains("https"))
        uri = Uri.https(apiConfig.api_url.replaceAll("https://", "").replaceAll("/api/", ""),"/api"+  url +apiConfig.api_token+"/"+apiConfig.item_purchase_code +"/");
      else
        uri=  Uri.http(apiConfig.api_url.replaceAll("http://", "").replaceAll("/api/", ""),  "/api"+url +apiConfig.api_token+"/"+apiConfig.item_purchase_code +"/");
      response  = await http.post(uri,body: data);
    }catch(ex){
      response = null;
    }
    print(uri);
    return  response;
  }

  static getMoviesByFiltres(int genre,String order,int page) async{
    return configUrl("/movie/by/filtres/${genre}/${order}/${page}/") ;
  }
  static getMoviesByGenres(genres) async{
    return configUrl("/movie/random/${genres}/") ;
  }
  static getSeriesByFiltres(int genre,String order,int page) async{
    return configUrl("/serie/by/filtres/${genre}/${order}/${page}/") ;
  }
  static getSeasonsBySerie(int id) async{
    return configUrl("/season/by/serie/${id}/") ;
  }
  static registerUser(var data) async{
    return configPost("/user/register/",data) ;
  }
  static loginUser(var data) async{
    return configPost("/user/login/",data) ;
  }
  static addCommentPoster(var data) async{

    return configPost("/comment/poster/add/",data) ;
  }
  static addCommentChannel(var data) async{
    return configPost("/comment/channel/add/",data) ;
  }
  static addReviewPoster(var data) async{
    return configPost("/rate/poster/add/",data) ;
  }
  static addReviewChannel(var data) async{
    return configPost("/rate/channel/add/",data) ;
  }
  static getGenres() async{
    return configUrl("/genre/all/") ;
  }

  static getCommentsByPoster(int id) async{
    return configUrl("/comments/by/poster/${id}/") ;
  }
  static getCommentsByChannel(int id) async{
    return configUrl("/comments/by/channel/${id}/") ;
  }

  static getReviewsByPoster(int id) async{
    return configUrl("/reviews/by/poster/${id}/") ;
  }
  static getReviewsByChannel(int id) async{
    return configUrl("/reviews/by/channel/${id}/") ;
  }
  static geCastByPoster(int id) async{
    return configUrl("/role/by/poster/${id}/") ;
  }
  static getSubtitlesByMovie(int id) async{
    return configUrl("/subtitles/by/movie/${id}/") ;
  }

  static getSubtitlesByEpisode(int id) async{
    return configUrl("/subtitles/by/episode/${id}/") ;
  }

  static getHomeData() async{
    return configUrl("/first/") ;
  }

  static getCountries() async{
    return configUrl("/country/all/") ;
  }

  static getCategories() async{
    return configUrl("/category/all/") ;
  }

  static getChannelsByFiltres(int country,int category, String order, int page) async{
    return configUrl("/channel/by/filtres/tv/${category}/${country}/${page}/${order}/") ;
  }

  static getChannelsByCategories(String categories) {
    return configUrl("/channel/random/${categories}/") ;
  }

  static getMoviesByActor(int id) {
    return configUrl("/movie/by/actor/${id}/") ;

  }

  static myList(int id,String key) {
    return configUrl("/mylist/${id}/${key}/") ;

  }

  static addMyList(var data) {
    return configPost("/add/mylist/",data) ;

  }

  static checkMyList(var data) {
    return configPost("/check/mylist/",data) ;

  }

  static searchByQuery(String query) {
    return configUrl("/search/${query}/") ;

  }

  static changePassword(int id, String old,String new_) {
    return configUrl("/user/password/${id}/${old}/${new_}/") ;

  }
  static check(int code, int user) {
    return configUrl("/version/check/${code}/${user}/") ;

  }
  static editProfile(var data) {

    return configPost("/user/edit/",data) ;

  }

  static getSubscriptions(var data) {
    return configPost("/subscription/user/",data) ;

  }

  static sendMessage(var data) {
    return configPost("/support/add/",data) ;

  }

}