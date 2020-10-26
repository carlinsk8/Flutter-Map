// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<String> query;
  List<Feature> features;
  String attribution;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.languageEs,
    this.placeNameEs,
    this.text,
    this.language,
    this.placeName,
    this.bbox,
    this.center,
    this.geometry,
    this.context,
    this.matchingText,
    this.matchingPlaceName,
  });

  String id;
  String type;
  List<String> placeType;
  double relevance;
  Properties properties;
  String textEs;
  Language languageEs;
  String placeNameEs;
  String text;
  Language language;
  String placeName;
  List<double> bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;
  String matchingText;
  String matchingPlaceName;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null
            ? null
            : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null
            ? null
            : languageValues.map[json["language"]],
        placeName: json["place_name"],
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
        matchingText:
            json["matching_text"] == null ? null : json["matching_text"],
        matchingPlaceName: json["matching_place_name"] == null
            ? null
            : json["matching_place_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "language_es":
            languageEs == null ? null : languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox.map((x) => x)),
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
        "matching_text": matchingText == null ? null : matchingText,
        "matching_place_name":
            matchingPlaceName == null ? null : matchingPlaceName,
      };
}

class Context {
  Context({
    this.id,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  Id id;
  Wikidata wikidata;

  Language languageEs;

  Language language;
  ShortCode shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: idValues.map[json["id"]],
        wikidata: wikidataValues.map[json["wikidata"]],
        languageEs: languageValues.map[json["language_es"]],
        language: languageValues.map[json["language"]],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "wikidata": wikidataValues.reverse[wikidata],
        "language_es": languageValues.reverse[languageEs],
        "language": languageValues.reverse[language],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

enum Id {
  PLACE_10859529414034610,
  REGION_9621727954423070,
  COUNTRY_11374003121964510,
  LOCALITY_10187601444914670
}

final idValues = EnumValues({
  "country.11374003121964510": Id.COUNTRY_11374003121964510,
  "locality.10187601444914670": Id.LOCALITY_10187601444914670,
  "place.10859529414034610": Id.PLACE_10859529414034610,
  "region.9621727954423070": Id.REGION_9621727954423070
});

enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

enum ShortCode { PE_LMA, PE }

final shortCodeValues =
    EnumValues({"pe": ShortCode.PE, "PE-LMA": ShortCode.PE_LMA});

enum Wikidata { Q2868, Q579240, Q419, Q3303762 }

final wikidataValues = EnumValues({
  "Q2868": Wikidata.Q2868,
  "Q3303762": Wikidata.Q3303762,
  "Q419": Wikidata.Q419,
  "Q579240": Wikidata.Q579240
});

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.wikidata,
    this.foursquare,
    this.landmark,
    this.category,
    this.address,
    this.maki,
  });

  Wikidata wikidata;
  String foursquare;
  bool landmark;
  String category;
  String address;
  String maki;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"] == null
            ? null
            : wikidataValues.map[json["wikidata"]],
        foursquare: json["foursquare"] == null ? null : json["foursquare"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        category: json["category"] == null ? null : json["category"],
        address: json["address"] == null ? null : json["address"],
        maki: json["maki"] == null ? null : json["maki"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        "foursquare": foursquare == null ? null : foursquare,
        "landmark": landmark == null ? null : landmark,
        "category": category == null ? null : category,
        "address": address == null ? null : address,
        "maki": maki == null ? null : maki,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
