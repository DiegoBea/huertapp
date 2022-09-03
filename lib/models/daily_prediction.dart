// To parse this JSON data, do
//
//     final aemet = aemetFromMap(jsonString);

import 'dart:convert';

import 'package:huertapp/helpers/helpers.dart';

class DailyPrediction {
  DailyPrediction({
    required this.origen,
    required this.elaborado,
    required this.nombre,
    required this.provincia,
    required this.prediccion,
    required this.id,
    required this.version,
  });

  OrigenDiario origen;
  DateTime elaborado;
  String nombre;
  String provincia;
  PrediccionDiaria prediccion;
  int id;
  double version;

  String get code {
    return origen.enlace.substring(origen.enlace.length - 5);
  }

  List<int> get probPrecipitation {
    List<int> precipitaciones = List.filled(7, 0);
    for (int i = 0; i < prediccion.dia.length; i++) {
      List<int> precipitaciones12h = [];
      List<int> precipitaciones6h = [];
      int precipitacion24h = 0;
      for (var precipitacion in prediccion.dia[i].probPrecipitacion) {
        if (precipitacion.periodo == null) {
          precipitaciones[i] = precipitacion.value;
          break;
        }

        if (precipitacion.periodo == "00-12" ||
            precipitacion.periodo == "12-24") {
          precipitaciones12h.add(precipitacion.value);
        }

        if (precipitacion.periodo == "00-06" ||
            precipitacion.periodo == "06-12" ||
            precipitacion.periodo == "12-18" ||
            precipitacion.periodo == "18-24") {
          precipitaciones6h.add(precipitacion.value);
        }

        if (precipitacion.periodo == "00-24") {
          precipitacion24h = precipitacion.value;
        }
      }

      // Aquí habremos obtenido todos los valores de cada 6hrs
      if (precipitaciones6h.length == 4) {
        int valorPrecipitaciones = 0;
        for (int probabilidad in precipitaciones6h) {
          valorPrecipitaciones += probabilidad;
        }
        precipitaciones[i] = valorPrecipitaciones ~/ 4;
        continue;
      }

      // Aquí habremos obtenido todos los valores de cada 12hrs
      if (precipitaciones12h.length == 2) {
        int valorPrecipitaciones = 0;
        for (int probabilidad in precipitaciones12h) {
          valorPrecipitaciones += probabilidad;
        }
        precipitaciones[i] = valorPrecipitaciones ~/ 2;
        continue;
      }

      if (precipitacion24h != 0) precipitaciones[i] = precipitacion24h;
    }
    return precipitaciones;
  }

  List<String> get skyValue {
    List<String> skyValues = List.filled(7, "11");
    for (var i = 0; i < prediccion.dia.length; i++) {
      for (var estadoCielo in prediccion.dia[i].estadoCielo) {
        if (estadoCielo.value == "") continue;
        skyValues[i] = estadoCielo.value;
        break;
      }
    }
    return skyValues;
  }

  Map<String, List<int>> get tempMinMaxValues {
    Map<String, List<int>> values = {};

    for (var i = 0; i < prediccion.dia.length; i++) {
      var day = DateTime.now().add(Duration(days: i)).weekday;

      values[DateHelper.getDynamicDayName(day)] = [
        prediccion.dia[i].temperatura.minima,
        prediccion.dia[i].temperatura.maxima
      ];
    }

    return values;
  }

  factory DailyPrediction.fromJson(String str) =>
      DailyPrediction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DailyPrediction.fromMap(Map<String, dynamic> json) => DailyPrediction(
        origen: OrigenDiario.fromMap(json["origen"]),
        elaborado: DateTime.parse(json["elaborado"]),
        nombre: json["nombre"],
        provincia: json["provincia"],
        prediccion: PrediccionDiaria.fromMap(json["prediccion"]),
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

class OrigenDiario {
  OrigenDiario({
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

  factory OrigenDiario.fromJson(String str) =>
      OrigenDiario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrigenDiario.fromMap(Map<String, dynamic> json) => OrigenDiario(
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

class PrediccionDiaria {
  PrediccionDiaria({
    required this.dia,
  });

  List<DiaDiaria> dia;

  factory PrediccionDiaria.fromJson(String str) =>
      PrediccionDiaria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrediccionDiaria.fromMap(Map<String, dynamic> json) =>
      PrediccionDiaria(
        dia: List<DiaDiaria>.from(json["dia"].map((x) => DiaDiaria.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "dia": List<dynamic>.from(dia.map((x) => x.toMap())),
      };
}

class DiaDiaria {
  DiaDiaria({
    required this.probPrecipitacion,
    required this.cotaNieveProv,
    required this.estadoCielo,
    required this.viento,
    required this.rachaMax,
    required this.temperatura,
    required this.sensTermica,
    required this.humedadRelativa,
    this.uvMax,
    required this.fecha,
  });

  List<ProbPrecipitacionDiaria> probPrecipitacion;
  List<CotaNieveProvDiaria> cotaNieveProv;
  List<EstadoCieloDiario> estadoCielo;
  List<VientoDiario> viento;
  List<CotaNieveProvDiaria> rachaMax;
  HumedadRelativaDiaria temperatura;
  HumedadRelativaDiaria sensTermica;
  HumedadRelativaDiaria humedadRelativa;
  int? uvMax;
  DateTime fecha;

  factory DiaDiaria.fromJson(String str) => DiaDiaria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiaDiaria.fromMap(Map<String, dynamic> json) => DiaDiaria(
        probPrecipitacion: List<ProbPrecipitacionDiaria>.from(
            json["probPrecipitacion"]
                .map((x) => ProbPrecipitacionDiaria.fromMap(x))),
        cotaNieveProv: List<CotaNieveProvDiaria>.from(
            json["cotaNieveProv"].map((x) => CotaNieveProvDiaria.fromMap(x))),
        estadoCielo: List<EstadoCieloDiario>.from(
            json["estadoCielo"].map((x) => EstadoCieloDiario.fromMap(x))),
        viento: List<VientoDiario>.from(
            json["viento"].map((x) => VientoDiario.fromMap(x))),
        rachaMax: List<CotaNieveProvDiaria>.from(
            json["rachaMax"].map((x) => CotaNieveProvDiaria.fromMap(x))),
        temperatura: HumedadRelativaDiaria.fromMap(json["temperatura"]),
        sensTermica: HumedadRelativaDiaria.fromMap(json["sensTermica"]),
        humedadRelativa: HumedadRelativaDiaria.fromMap(json["humedadRelativa"]),
        uvMax: json["uvMax"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toMap() => {
        "probPrecipitacion":
            List<dynamic>.from(probPrecipitacion.map((x) => x.toMap())),
        "cotaNieveProv":
            List<dynamic>.from(cotaNieveProv.map((x) => x.toMap())),
        "estadoCielo": List<dynamic>.from(estadoCielo.map((x) => x.toMap())),
        "viento": List<dynamic>.from(viento.map((x) => x.toMap())),
        "rachaMax": List<dynamic>.from(rachaMax.map((x) => x.toMap())),
        "temperatura": temperatura.toMap(),
        "sensTermica": sensTermica.toMap(),
        "humedadRelativa": humedadRelativa.toMap(),
        "uvMax": uvMax,
        "fecha": fecha.toIso8601String(),
      };
}

class CotaNieveProvDiaria {
  CotaNieveProvDiaria({
    required this.value,
    this.periodo,
  });

  String value;
  String? periodo;

  factory CotaNieveProvDiaria.fromJson(String str) =>
      CotaNieveProvDiaria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CotaNieveProvDiaria.fromMap(Map<String, dynamic> json) =>
      CotaNieveProvDiaria(
        value: json["value"],
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
      };
}

class EstadoCieloDiario {
  EstadoCieloDiario({
    required this.value,
    this.periodo,
    required this.descripcion,
  });

  String value;
  String? periodo;
  String descripcion;

  factory EstadoCieloDiario.fromJson(String str) =>
      EstadoCieloDiario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstadoCieloDiario.fromMap(Map<String, dynamic> json) =>
      EstadoCieloDiario(
        value: json["value"],
        periodo: json["periodo"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
        "descripcion": descripcion,
      };
}

class HumedadRelativaDiaria {
  HumedadRelativaDiaria({
    required this.maxima,
    required this.minima,
    required this.dato,
  });

  int maxima;
  int minima;
  List<DatoDiario> dato;

  factory HumedadRelativaDiaria.fromJson(String str) =>
      HumedadRelativaDiaria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HumedadRelativaDiaria.fromMap(Map<String, dynamic> json) =>
      HumedadRelativaDiaria(
        maxima: json["maxima"],
        minima: json["minima"],
        dato: List<DatoDiario>.from(
            json["dato"].map((x) => DatoDiario.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "maxima": maxima,
        "minima": minima,
        "dato": List<dynamic>.from(dato.map((x) => x.toMap())),
      };
}

class DatoDiario {
  DatoDiario({
    required this.value,
    required this.hora,
  });

  int value;
  int hora;

  factory DatoDiario.fromJson(String str) =>
      DatoDiario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatoDiario.fromMap(Map<String, dynamic> json) => DatoDiario(
        value: json["value"],
        hora: json["hora"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "hora": hora,
      };
}

class ProbPrecipitacionDiaria {
  ProbPrecipitacionDiaria({
    required this.value,
    this.periodo,
  });

  int value;
  String? periodo;

  factory ProbPrecipitacionDiaria.fromJson(String str) =>
      ProbPrecipitacionDiaria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProbPrecipitacionDiaria.fromMap(Map<String, dynamic> json) =>
      ProbPrecipitacionDiaria(
        value: json["value"],
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
      };
}

class VientoDiario {
  VientoDiario({
    required this.direccion,
    required this.velocidad,
    this.periodo,
  });

  String direccion;
  int velocidad;
  String? periodo;

  factory VientoDiario.fromJson(String str) =>
      VientoDiario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VientoDiario.fromMap(Map<String, dynamic> json) => VientoDiario(
        direccion: json["direccion"],
        velocidad: json["velocidad"],
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "direccion": direccion,
        "velocidad": velocidad,
        "periodo": periodo,
      };
}
