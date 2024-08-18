/// Clase de utilidad que contiene métodos de validación estáticos.
class Validators {
  /// Valida el nombre de usuario.
  ///
  /// Reglas de validación:
  /// - No debe estar vacío.
  /// - Debe tener entre 4 y 50 caracteres.
  /// - Debe contener solo letras.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es obligatorio';
    } else if (value.length < 4 || value.length > 50) {
      return 'El nombre de usuario debe tener entre 4 y 50 caracteres';
    } else if (RegExp(r'[^a-zA-Z]').hasMatch(value)) {
      return 'El nombre de usuario debe contener solo letras';
    }
    return null;
  }

  /// Valida la dirección de correo electrónico.
  ///
  /// Reglas de validación:
  /// - No debe estar vacío.
  /// - Debe cumplir con el formato de una dirección de correo electrónico válida.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Correo electrónico es obligatorio';
    } else if (!RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$')
        .hasMatch(value)) {
      return 'Introduzca una dirección de correo electrónico válida';
    }
    return null;
  }

  /// Valida la contraseña.
  ///
  /// Reglas de validación:
  /// - No debe estar vacía.
  /// - Debe tener entre 10 y 60 caracteres.
  /// - Debe incluir mayúsculas, minúsculas, números y caracteres especiales.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Se requiere contraseña';
    } else if (value.length < 10 || value.length > 60) {
      return 'La contraseña debe tener entre 10 y 60 caracteres.';
    } else if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{10,}$')
        .hasMatch(value)) {
      return 'La contraseña debe incluir mayúsculas, minúsculas, números y caracteres especiales.';
    }
    return null;
  }

  /// Valida la confirmación de la contraseña.
  ///
  /// Reglas de validación:
  /// - No debe estar vacía.
  /// - Debe coincidir con la contraseña proporcionada.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    } else if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Valida el nombre de contacto.
  ///
  /// Reglas de validación:
  /// - No debe estar vacío.
  /// - Debe tener entre 2 y 50 caracteres.
  /// - Debe contener solo letras.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? contactNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de contacto es obligatorio';
    } else if (value.length < 2 || value.length > 50) {
      return 'El nombre de contacto debe tener entre 2 y 50 caracteres.';
    } else if (RegExp(r'[^a-zA-Z]').hasMatch(value)) {
      return 'El nombre de contacto debe contener solo letras';
    }
    return null;
  }

  /// Valida el ID de contacto.
  ///
  /// Reglas de validación:
  /// - No debe estar vacío.
  /// - Debe tener entre 6 y 10 caracteres.
  /// - Debe contener solo números.
  ///
  /// Retorna un mensaje de error si no se cumple alguna regla, de lo contrario, retorna `null`.
  static String? contactIdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Se requiere identificación';
    } else if (value.length < 6 || value.length > 10) {
      return 'El ID debe tener entre 6 y 10 caracteres';
    } else if (RegExp(r'[^0-9]').hasMatch(value)) {
      return 'La identificación debe contener solo números';
    }
    return null;
  }
}
