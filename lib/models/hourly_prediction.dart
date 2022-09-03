// To parse this JSON data, do
//
//     final hourlyPrediction = hourlyPredictionFromMap(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

class HourlyPrediction {
  HourlyPrediction({
    required this.origen,
    required this.elaborado,
    required this.nombre,
    required this.provincia,
    required this.prediccion,
    required this.id,
    required this.version,
  });

  Origen origen;
  DateTime elaborado;
  String nombre;
  String provincia;
  Prediccion prediccion;
  String id;
  String version;

  String get code {
    return origen.enlace.substring(origen.enlace.length - 5);
  }

  String get currentTemperature {
    return prediccion.dia[0].temperatura
        .where((element) => int.parse(element.periodo) == DateTime.now().hour)
        .first
        .value;
  }

  String get currentSkyValue {
    return prediccion.dia[0].estadoCielo
        .where((element) => int.parse(element.periodo) == DateTime.now().hour)
        .first
        .value;
  }

  bool get isDay {
    DateTime now = DateTime.now();

    String ocaso = prediccion.dia[0].ocaso;
    List<String> ocasoSplitted = ocaso.split(":");
    DateTime ocasoDate = DateTime(now.year, now.month, now.day,
        int.parse(ocasoSplitted[0]), int.parse(ocasoSplitted[1]));

    String orto = prediccion.dia[0].orto;
    List<String> ortoSplitted = orto.split(":");
    DateTime ortoDate = DateTime(now.year, now.month, now.day,
        int.parse(ortoSplitted[0]), int.parse(ortoSplitted[1]));

    return now.isAfter(ortoDate) && now.isBefore(ocasoDate);
  }

  factory HourlyPrediction.fromJson(String str) =>
      HourlyPrediction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlyPrediction.fromMap(Map<String, dynamic> json) =>
      HourlyPrediction(
        origen: Origen.fromMap(json["origen"]),
        elaborado: DateTime.parse(json["elaborado"]),
        nombre: json["nombre"],
        provincia: json["provincia"],
        prediccion: Prediccion.fromMap(json["prediccion"]),
        id: json["id"],
        version: json["version"],
      );

  Map<String, dynamic> toMap() => {
        "origen": origen.toMap(),
        "elaborado": elaborado.toIso8601String(),
        "nombre": nombre,
        "provincia": provincia,
        "prediccion": prediccion.toMap(),
        "id": id,
        "version": version,
      };
}

class Origen {
  Origen({
    required this.productor,
    required this.web,
    required this.enlace,
    required this.language,
    required this.copyright,
    required this.notaLegal,
  });

  String productor;
  String web;
  String enlace;
  String language;
  String copyright;
  String notaLegal;

  factory Origen.fromJson(String str) => Origen.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Origen.fromMap(Map<String, dynamic> json) => Origen(
        productor: json["productor"],
        web: json["web"],
        enlace: json["enlace"],
        language: json["language"],
        copyright: json["copyright"],
        notaLegal: json["notaLegal"],
      );

  Map<String, dynamic> toMap() => {
        "productor": productor,
        "web": web,
        "enlace": enlace,
        "language": language,
        "copyright": copyright,
        "notaLegal": notaLegal,
      };
}

class Prediccion {
  Prediccion({
    required this.dia,
  });

  List<Dia> dia;

  factory Prediccion.fromJson(String str) =>
      Prediccion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Prediccion.fromMap(Map<String, dynamic> json) => Prediccion(
        dia: List<Dia>.from(json["dia"].map((x) => Dia.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "dia": List<dynamic>.from(dia.map((x) => x.toMap())),
      };
}

class Dia {
  Dia({
    required this.estadoCielo,
    required this.precipitacion,
    required this.probPrecipitacion,
    required this.probTormenta,
    required this.nieve,
    required this.probNieve,
    required this.temperatura,
    required this.sensTermica,
    required this.humedadRelativa,
    required this.vientoAndRachaMax,
    required this.fecha,
    required this.orto,
    required this.ocaso,
  });

  List<EstadoCielo> estadoCielo;
  List<HumedadRelativa>? precipitacion;
  List<HumedadRelativa> probPrecipitacion;
  List<HumedadRelativa>? probTormenta;
  List<HumedadRelativa>? nieve;
  List<HumedadRelativa>? probNieve;
  List<HumedadRelativa> temperatura;
  List<HumedadRelativa> sensTermica;
  List<HumedadRelativa> humedadRelativa;
  List<VientoAndRachaMax> vientoAndRachaMax;
  DateTime fecha;
  String orto;
  String ocaso;

  factory Dia.fromJson(String str) => Dia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dia.fromMap(Map<String, dynamic> json) => Dia(
        estadoCielo: List<EstadoCielo>.from(
            json["estadoCielo"].map((x) => EstadoCielo.fromMap(x))),
        precipitacion: json["precipitacion"] == null
            ? null
            : List<HumedadRelativa>.from(
                json["precipitacion"].map((x) => HumedadRelativa.fromMap(x))),
        probPrecipitacion: List<HumedadRelativa>.from(
            json["probPrecipitacion"].map((x) => HumedadRelativa.fromMap(x))),
        probTormenta: json["probTormenta"] == null
            ? null
            : List<HumedadRelativa>.from(
                json["probTormenta"].map((x) => HumedadRelativa.fromMap(x))),
        nieve: json["nieve"] == null
            ? null
            : List<HumedadRelativa>.from(
                json["nieve"].map((x) => HumedadRelativa.fromMap(x))),
        probNieve: json["probNieve"] == null
            ? null
            : List<HumedadRelativa>.from(
                json["probNieve"].map((x) => HumedadRelativa.fromMap(x))),
        temperatura: List<HumedadRelativa>.from(
            json["temperatura"].map((x) => HumedadRelativa.fromMap(x))),
        sensTermica: List<HumedadRelativa>.from(
            json["sensTermica"].map((x) => HumedadRelativa.fromMap(x))),
        humedadRelativa: List<HumedadRelativa>.from(
            json["humedadRelativa"].map((x) => HumedadRelativa.fromMap(x))),
        vientoAndRachaMax: List<VientoAndRachaMax>.from(
            json["vientoAndRachaMax"].map((x) => VientoAndRachaMax.fromMap(x))),
        fecha: DateTime.parse(json["fecha"]),
        orto: json["orto"],
        ocaso: json["ocaso"],
      );

  Map<String, dynamic> toMap() => {
        "estadoCielo": List<dynamic>.from(estadoCielo.map((x) => x.toMap())),
        "precipitacion": precipitacion == null
            ? null
            : List<dynamic>.from(precipitacion!.map((x) => x.toMap())),
        "probPrecipitacion":
            List<dynamic>.from(probPrecipitacion.map((x) => x.toMap())),
        "probTormenta": probTormenta == null
            ? null
            : List<dynamic>.from(probTormenta!.map((x) => x.toMap())),
        "nieve": nieve == null
            ? null
            : List<dynamic>.from(nieve!.map((x) => x.toMap())),
        "probNieve": probNieve == null
            ? null
            : List<dynamic>.from(probNieve!.map((x) => x.toMap())),
        "temperatura": List<dynamic>.from(temperatura.map((x) => x.toMap())),
        "sensTermica": List<dynamic>.from(sensTermica.map((x) => x.toMap())),
        "humedadRelativa":
            List<dynamic>.from(humedadRelativa.map((x) => x.toMap())),
        "vientoAndRachaMax":
            List<dynamic>.from(vientoAndRachaMax.map((x) => x.toMap())),
        "fecha": fecha.toIso8601String(),
        "orto": orto,
        "ocaso": ocaso,
      };
}

class EstadoCielo {
  EstadoCielo({
    required this.value,
    required this.periodo,
    this.descripcion,
  });

  String value;
  String periodo;
  Descripcion? descripcion;

  factory EstadoCielo.fromJson(String str) =>
      EstadoCielo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstadoCielo.fromMap(Map<String, dynamic> json) => EstadoCielo(
        value: json["value"],
        periodo: json["periodo"],
        descripcion: descripcionValues.map[json["descripcion"]],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
        "descripcion": descripcionValues.reverse[descripcion],
      };
}

enum Descripcion { POCO_NUBOSO, DESPEJADO, NUBES_ALTAS, NUBOSO, CUBIERTO }

final descripcionValues = EnumValues({
  "Cubierto": Descripcion.CUBIERTO,
  "Despejado": Descripcion.DESPEJADO,
  "Nubes altas": Descripcion.NUBES_ALTAS,
  "Nuboso": Descripcion.NUBOSO,
  "Poco nuboso": Descripcion.POCO_NUBOSO
});

class HumedadRelativa {
  HumedadRelativa({
    required this.value,
    required this.periodo,
  });

  String value;
  String periodo;

  factory HumedadRelativa.fromJson(String str) =>
      HumedadRelativa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HumedadRelativa.fromMap(Map<String, dynamic> json) => HumedadRelativa(
        value: json["value"].toString(),
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
      };
}

class VientoAndRachaMax {
  VientoAndRachaMax({
    required this.direccion,
    required this.velocidad,
    required this.periodo,
    required this.value,
  });

  List<String>? direccion;
  List<String>? velocidad;
  String periodo;
  String? value;

  factory VientoAndRachaMax.fromJson(String str) =>
      VientoAndRachaMax.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VientoAndRachaMax.fromMap(Map<String, dynamic> json) =>
      VientoAndRachaMax(
        direccion: json["direccion"] == null
            ? null
            : List<String>.from(json["direccion"].map((x) => x)),
        velocidad: json["velocidad"] == null
            ? null
            : List<String>.from(json["velocidad"].map((x) => x)),
        periodo: json["periodo"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "direccion": direccion == null
            ? null
            : List<dynamic>.from(direccion!.map((x) => x)),
        "velocidad": velocidad == null
            ? null
            : List<dynamic>.from(velocidad!.map((x) => x)),
        "periodo": periodo,
        "value": value,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
