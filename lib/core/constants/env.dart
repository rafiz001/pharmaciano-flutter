
class Env {
  static String get apiBaseUrl =>  'https://pharmaciano-backend.vercel.app';
  static String get apiVersion => 'v1';
  static String get jwtSecret =>  'i-am-rafiz';
  static String get appName =>  'Pharmaciano';
  
  static String get loginEndpoint => '$apiBaseUrl/api/$apiVersion/auth/login';
  static String get profileEndpoint => '$apiBaseUrl/api/$apiVersion/users/profile';

  static String get getInventoryBatchesEndpoint => '$apiBaseUrl/api/$apiVersion/inventory-batches';
  static String get getAllMedicinesEndpoint => '$apiBaseUrl/api/$apiVersion/medicines';

  
  

}
