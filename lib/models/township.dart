// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class Township {
    Township({
        required this.codigoine,
        required this.idRel,
        required this.codGeo,
        required this.codprov,
        required this.nombreProvincia,
        required this.nombre,
        required this.poblacionMuni,
        required this.superficie,
        required this.perimetro,
        required this.codigoineCapital,
        required this.nombreCapital,
        required this.poblacionCapital,
        required this.hojaMtn25,
        required this.longitudEtrs89Regcan95,
        required this.latitudEtrs89Regcan95,
        required this.origenCoord,
        required this.altitud,
        required this.origenAltitud,
        required this.discrepanteIne,
    });

    String codigoine;
    String idRel;
    String codGeo;
    String codprov;
    String nombreProvincia;
    String nombre;
    int poblacionMuni;
    double superficie;
    int perimetro;
    String codigoineCapital;
    String nombreCapital;
    String poblacionCapital;
    String hojaMtn25;
    double longitudEtrs89Regcan95;
    double latitudEtrs89Regcan95;
    String origenCoord;
    double altitud;
    String origenAltitud;
    int discrepanteIne;

    factory Township.fromJson(String str) => Township.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Township.fromMap(Map<String, dynamic> json) => Township(
        codigoine: json["CODIGOINE"],
        idRel: json["ID_REL"],
        codGeo: json["COD_GEO"],
        codprov: json["CODPROV"],
        nombreProvincia: json["NOMBRE_PROVINCIA"],
        nombre: json["NOMBRE"],
        poblacionMuni: json["POBLACION_MUNI"],
        superficie: json["SUPERFICIE"].toDouble(),
        perimetro: json["PERIMETRO"],
        codigoineCapital: json["CODIGOINE_CAPITAL"],
        nombreCapital: json["NOMBRE_CAPITAL"],
        poblacionCapital: json["POBLACION_CAPITAL"],
        hojaMtn25: json["HOJA_MTN25"],
        longitudEtrs89Regcan95: json["LONGITUD_ETRS89_REGCAN95"].toDouble(),
        latitudEtrs89Regcan95: json["LATITUD_ETRS89_REGCAN95"].toDouble(),
        origenCoord: json["ORIGEN_COORD"],
        altitud: json["ALTITUD"].toDouble(),
        origenAltitud: json["ORIGEN_ALTITUD"],
        discrepanteIne: json["DISCREPANTE_INE"],
    );

    Map<String, dynamic> toMap() => {
        "CODIGOINE": codigoine,
        "ID_REL": idRel,
        "COD_GEO": codGeo,
        "CODPROV": codprov,
        "NOMBRE_PROVINCIA": nombreProvincia,
        "NOMBRE": nombre,
        "POBLACION_MUNI": poblacionMuni,
        "SUPERFICIE": superficie,
        "PERIMETRO": perimetro,
        "CODIGOINE_CAPITAL": codigoineCapital,
        "NOMBRE_CAPITAL": nombreCapital,
        "POBLACION_CAPITAL": poblacionCapital,
        "HOJA_MTN25": hojaMtn25,
        "LONGITUD_ETRS89_REGCAN95": longitudEtrs89Regcan95,
        "LATITUD_ETRS89_REGCAN95": latitudEtrs89Regcan95,
        "ORIGEN_COORD": origenCoord,
        "ALTITUD": altitud,
        "ORIGEN_ALTITUD": origenAltitud,
        "DISCREPANTE_INE": discrepanteIne,
    };
}