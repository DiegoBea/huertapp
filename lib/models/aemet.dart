// To parse this JSON data, do
//
//     final aemet = aemetFromMap(jsonString);

import 'dart:convert';

import 'package:huertapp/helpers/helpers.dart';

class Aemet {
  Aemet({
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
  int id;
  double version;

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

  // Map<String, Cielo> get skyStateValues {
  //   Map<String, Cielo> values = {};

  //   for (int i = 0; i < prediccion.dia.length; i++) {
  //     List<EstadoCielo> estadosCielo = prediccion.dia[i].estadoCielo;
  //     // Se inicializa en 11 ya que tomaré el valor "despejado" por defecto
  //     List<String> skyValues = List.filled(24, "11");
  //     List<String> descriptions = List.filled(24, "Despejado");
  //     List<String> imageUrls = List.filled(
  //         24, "https://www.aemet.es/imagenes_gcd/_iconos_municipios/11.png");

  //     for (EstadoCielo estadoCielo in estadosCielo) {
  //       if (estadoCielo.periodo == null) continue;

  //       List<String> intervalo = estadoCielo.periodo!.split("-");
  //       int min = int.parse(intervalo[0]);
  //       int max = int.parse(intervalo[1]);

  //       for (int i = min; i < max; i++) {
  //         String value = estadoCielo.value;
  //         skyValues[i] = value != "" ? value : "11";
  //         descriptions[i] = estadoCielo.descripcion != ""
  //             ? estadoCielo.descripcion
  //             : "Despejado";
  //         imageUrls[i] =
  //             "https://www.aemet.es/imagenes_gcd/_iconos_municipios/${value != "" ? value : 11}.png";
  //       }
  //     }

  //     values[DateHelper.getDynamicDayName(
  //             DateTime.now().add(Duration(days: i)).weekday)] =
  //         Cielo(
  //             values: skyValues,
  //             imageUrl: imageUrls,
  //             description: descriptions);
  //   }

  //   return values;
  // }

  // Map<String, Map<int, int>> get tempValues {
  //   Map<String, Map<int, int>> temps = {};
  //   Map<int, int> hourValue = {};

  //   for (var i = 0; i < prediccion.dia.length; i++) {
  //     hourValue.clear();
  //     for (Dato dato in prediccion.dia[i].temperatura.dato) {
  //       hourValue[dato.hora] = dato.value;
  //     }
  //     var day = DateTime.now().add(Duration(days: i)).weekday;
  //     temps[DateHelper.getDynamicDayName(day)] = Map<int, int>.from(hourValue);
  //   }

  //   return temps;
  // }

  // Map<String, List<int>> get rainProbabilities {
  //   Map<String, List<int>> values = {};

  //   for (int i = 0; i < prediccion.dia.length; i++) {
  //     List<ProbPrecipitacion> probPrecipitaciones =
  //         prediccion.dia[i].probPrecipitacion;
  //     // Se inicializa en 0 ya que tomaré el valor "0%" por defecto
  //     List<int> rainValues = List.filled(24, 0);

  //     for (ProbPrecipitacion prob in probPrecipitaciones) {
  //       if (prob.periodo == null) continue;

  //       List<String> intervalo = prob.periodo!.split("-");
  //       int min = int.parse(intervalo[0]);
  //       int max = int.parse(intervalo[1]);

  //       for (int i = min; i < max; i++) {
  //         int value = prob.value;
  //         rainValues[i] = (value);
  //       }
  //     }

  //     values[DateHelper.getDynamicDayName(
  //         DateTime.now().add(Duration(days: i)).weekday)] = rainValues;
  //   }

  //   return values;
  // }

  factory Aemet.fromJson(String str) => Aemet.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Aemet.fromMap(Map<String, dynamic> json) => Aemet(
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

class Cielo {
  Cielo({
    required this.values,
    required this.imageUrl,
    required this.description,
  });

  List<String> values;
  List<String> imageUrl;
  List<String> description;
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

  List<ProbPrecipitacion> probPrecipitacion;
  List<CotaNieveProv> cotaNieveProv;
  List<EstadoCielo> estadoCielo;
  List<Viento> viento;
  List<CotaNieveProv> rachaMax;
  HumedadRelativa temperatura;
  HumedadRelativa sensTermica;
  HumedadRelativa humedadRelativa;
  int? uvMax;
  DateTime fecha;

  factory Dia.fromJson(String str) => Dia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dia.fromMap(Map<String, dynamic> json) => Dia(
        probPrecipitacion: List<ProbPrecipitacion>.from(
            json["probPrecipitacion"].map((x) => ProbPrecipitacion.fromMap(x))),
        cotaNieveProv: List<CotaNieveProv>.from(
            json["cotaNieveProv"].map((x) => CotaNieveProv.fromMap(x))),
        estadoCielo: List<EstadoCielo>.from(
            json["estadoCielo"].map((x) => EstadoCielo.fromMap(x))),
        viento: List<Viento>.from(json["viento"].map((x) => Viento.fromMap(x))),
        rachaMax: List<CotaNieveProv>.from(
            json["rachaMax"].map((x) => CotaNieveProv.fromMap(x))),
        temperatura: HumedadRelativa.fromMap(json["temperatura"]),
        sensTermica: HumedadRelativa.fromMap(json["sensTermica"]),
        humedadRelativa: HumedadRelativa.fromMap(json["humedadRelativa"]),
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

class CotaNieveProv {
  CotaNieveProv({
    required this.value,
    this.periodo,
  });

  String value;
  String? periodo;

  factory CotaNieveProv.fromJson(String str) =>
      CotaNieveProv.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CotaNieveProv.fromMap(Map<String, dynamic> json) => CotaNieveProv(
        value: json["value"],
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
      };
}

class EstadoCielo {
  EstadoCielo({
    required this.value,
    this.periodo,
    required this.descripcion,
  });

  String value;
  String? periodo;
  String descripcion;

  factory EstadoCielo.fromJson(String str) =>
      EstadoCielo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstadoCielo.fromMap(Map<String, dynamic> json) => EstadoCielo(
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

class HumedadRelativa {
  HumedadRelativa({
    required this.maxima,
    required this.minima,
    required this.dato,
  });

  int maxima;
  int minima;
  List<Dato> dato;

  factory HumedadRelativa.fromJson(String str) =>
      HumedadRelativa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HumedadRelativa.fromMap(Map<String, dynamic> json) => HumedadRelativa(
        maxima: json["maxima"],
        minima: json["minima"],
        dato: List<Dato>.from(json["dato"].map((x) => Dato.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "maxima": maxima,
        "minima": minima,
        "dato": List<dynamic>.from(dato.map((x) => x.toMap())),
      };
}

class Dato {
  Dato({
    required this.value,
    required this.hora,
  });

  int value;
  int hora;

  factory Dato.fromJson(String str) => Dato.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dato.fromMap(Map<String, dynamic> json) => Dato(
        value: json["value"],
        hora: json["hora"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "hora": hora,
      };
}

class ProbPrecipitacion {
  ProbPrecipitacion({
    required this.value,
    this.periodo,
  });

  int value;
  String? periodo;

  factory ProbPrecipitacion.fromJson(String str) =>
      ProbPrecipitacion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProbPrecipitacion.fromMap(Map<String, dynamic> json) =>
      ProbPrecipitacion(
        value: json["value"],
        periodo: json["periodo"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "periodo": periodo,
      };
}

class Viento {
  Viento({
    required this.direccion,
    required this.velocidad,
    this.periodo,
  });

  String direccion;
  int velocidad;
  String? periodo;

  factory Viento.fromJson(String str) => Viento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Viento.fromMap(Map<String, dynamic> json) => Viento(
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
