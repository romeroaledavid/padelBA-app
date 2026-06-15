import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../painters/diagonal_bg_painter.dart';
import 'seleccionar_formato_screen.dart';

class ContratoOrganizadorScreen extends StatefulWidget {
  final Map<String, dynamic> perfil;
  const ContratoOrganizadorScreen({super.key, required this.perfil});
  @override
  State<ContratoOrganizadorScreen> createState() => _ContratoOrganizadorScreenState();
}

class _ContratoOrganizadorScreenState extends State<ContratoOrganizadorScreen> {
  final _scrollCtrl = ScrollController();
  bool _leyoTodo    = false;
  bool _acepto      = false;
  bool _guardando   = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 40) {
      if (!_leyoTodo) setState(() => _leyoTodo = true);
    }
  }

  @override
  void dispose() { _scrollCtrl.dispose(); super.dispose(); }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.barlowCondensed(fontSize: 15)),
      backgroundColor: error ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _aceptarYContinuar() async {
    if (!_acepto) {
      _toast('Debés aceptar los términos para continuar', error: true); return;
    }
    setState(() => _guardando = true);
    try {
      final uid    = Supabase.instance.client.auth.currentUser?.id;
      final nombre = widget.perfil['nombre'] as String? ?? '';
      final apellido = widget.perfil['apellido'] as String? ?? '';
      final clubes = widget.perfil['clubes'];
      final clubStr = clubes is List
          ? (clubes as List).join(', ')
          : (clubes?.toString() ?? '');
      final dni = Supabase.instance.client.auth.currentUser?.email
              ?.replaceAll('dni', '').replaceAll('@padelba.app', '') ?? '';

      await Supabase.instance.client.from('contratos_organizador').insert({
        'usuario_id'       : uid,
        'dni'              : dni,
        'nombre'           : nombre,
        'apellido'         : apellido,
        'club'             : clubStr.isNotEmpty ? clubStr : null,
        'fecha_aceptacion' : DateTime.now().toIso8601String(),
        'version_contrato' : 'v1.0',
      });

      if (!mounted) return;
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const SeleccionarFormatoScreen()));
    } catch (e) {
      _toast('Error al registrar aceptación: $e', error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre   = widget.perfil['nombre'] as String? ?? '';
    final apellido = widget.perfil['apellido'] as String? ?? '';
    final hoy      = DateTime.now();
    final fechaStr = '${hoy.day.toString().padLeft(2,'0')}/${hoy.month.toString().padLeft(2,'0')}/${hoy.year}';

    return Scaffold(
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.navy, AppColors.navy2],
        ))),
        CustomPaint(painter: DiagonalBgPainter(), child: Container()),
        SafeArea(child: Column(children: [

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.blueBright.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined, color: AppColors.blueBright, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CONTRATO DE USO', style: GoogleFonts.bebasNeue(fontSize: 22, letterSpacing: 2, color: Colors.white)),
                Text('Leé y aceptá los términos para continuar',
                  style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 1, color: AppColors.white30)),
              ])),
              // Indicador de lectura
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _leyoTodo ? AppColors.green.withOpacity(0.15) : AppColors.white05,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _leyoTodo ? AppColors.green : AppColors.white10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_leyoTodo ? Icons.check_circle_outline : Icons.hourglass_empty,
                    color: _leyoTodo ? AppColors.green : AppColors.white30, size: 13),
                  const SizedBox(width: 4),
                  Text(_leyoTodo ? 'Leído' : 'Scrolleá',
                    style: GoogleFonts.barlowCondensed(fontSize: 11,
                      color: _leyoTodo ? AppColors.green : AppColors.white30)),
                ]),
              ),
            ]),
          ),
          const Divider(color: AppColors.white10, height: 1),

          // Contenido del contrato
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // Encabezado formal
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white05,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ACUERDO DE USO DE PLATAFORMA',
                      style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 2, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('PadelBA · Versión 1.0 · $fechaStr',
                      style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30)),
                    const SizedBox(height: 8),
                    Text('Entre PadelBA (en adelante "la Plataforma") y $nombre $apellido (en adelante "el Organizador"), se establece el presente acuerdo de uso para la creación y gestión de torneos a través de la aplicación PadelBA.',
                      style: GoogleFonts.barlow(fontSize: 13, color: Colors.white, height: 1.6)),
                  ]),
                ),
                const SizedBox(height: 20),

                _clausula('1', 'ACCESO Y AUTORIZACIÓN',
                  'El Organizador declara haber sido autorizado por PadelBA para acceder al módulo de creación de torneos. Este acceso es personal, intransferible y no puede ser cedido a terceros bajo ninguna circunstancia. Cualquier uso indebido de las credenciales de acceso será responsabilidad exclusiva del Organizador.'),

                _clausula('2', 'ARANCEL POR JUGADOR INSCRIPTO',
                  'El Organizador acepta abonar a PadelBA la suma de \$1.400 (pesos argentinos mil cuatrocientos) por cada jugador inscripto en el torneo creado, con independencia de si el jugador efectivamente participa. El pago se realizará en forma diferida, dentro de los 7 (siete) días posteriores a la finalización del torneo.'),

                _clausula('3', 'LIQUIDACIÓN Y FACTURACIÓN',
                  'PadelBA emitirá una liquidación detallada al cierre de cada torneo con el total de jugadores inscriptos y el monto correspondiente. El Organizador recibirá la liquidación por correo electrónico o a través de la aplicación. La falta de pago en término devengará un interés punitorio del 5% mensual sobre el saldo adeudado.'),

                _clausula('4', 'OBLIGACIONES DEL ORGANIZADOR',
                  'El Organizador se compromete a:\n\n· Completar correctamente todos los datos del torneo (fecha, lugar, categorías, canchas disponibles).\n· Informar a los jugadores sobre el reglamento vigente de PadelBA.\n· Garantizar que el torneo se desarrolle en condiciones de seguridad e higiene adecuadas.\n· No modificar datos del torneo una vez iniciada la instancia de inscripción sin notificación previa a PadelBA.\n· Comunicar cualquier cancelación con al menos 48 horas de anticipación.'),

                _clausula('5', 'CANCELACIÓN DE TORNEO',
                  'En caso de cancelación del torneo por causas atribuibles al Organizador, este deberá abonar el 30% del arancel estimado en base a las inscripciones recibidas hasta el momento de la cancelación, en concepto de gastos administrativos y daño a los jugadores inscriptos.'),

                _clausula('6', 'PROPIEDAD DE LOS DATOS',
                  'Los datos de los jugadores inscriptos son propiedad de PadelBA. El Organizador puede acceder a los mismos exclusivamente para la gestión del torneo y queda expresamente prohibido su uso con fines comerciales, publicitarios o de cualquier otra naturaleza ajena a la organización del torneo.'),

                _clausula('7', 'IMAGEN Y COMUNICACIÓN',
                  'PadelBA podrá utilizar el nombre del torneo, los resultados y las imágenes del evento con fines de comunicación en redes sociales y medios propios. El Organizador autoriza este uso sin derecho a contraprestación económica.'),

                _clausula('8', 'RESPONSABILIDAD',
                  'PadelBA actúa como plataforma tecnológica y no se responsabiliza por accidentes, lesiones, daños materiales o conflictos que surjan durante el desarrollo del torneo. El Organizador asume la responsabilidad civil y legal sobre el evento de forma exclusiva.'),

                _clausula('9', 'INCUMPLIMIENTO',
                  'El incumplimiento de cualquiera de las cláusulas del presente acuerdo faculta a PadelBA a suspender el acceso del Organizador a la plataforma en forma inmediata y sin previo aviso, sin perjuicio de las acciones legales que pudieran corresponder.'),

                _clausula('10', 'JURISDICCIÓN',
                  'Para cualquier controversia derivada del presente acuerdo, las partes se someten a la jurisdicción de los Tribunales Ordinarios de la Ciudad Autónoma de Buenos Aires, renunciando a cualquier otro fuero que pudiera corresponderles.'),

                const SizedBox(height: 20),

                // Firma digital
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.yellow.withOpacity(0.2)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('FIRMA DIGITAL', style: GoogleFonts.barlowCondensed(fontSize: 11, letterSpacing: 3, color: AppColors.yellow)),
                    const SizedBox(height: 8),
                    Text('Al tildar "Acepto" y presionar "Aceptar y Continuar", $nombre $apellido confirma haber leído, comprendido y aceptado la totalidad de las cláusulas del presente acuerdo, con fecha $fechaStr.',
                      style: GoogleFonts.barlow(fontSize: 12, color: AppColors.white30, height: 1.6)),
                  ]),
                ),
                const SizedBox(height: 28),

                // Checkbox acepto
                GestureDetector(
                  onTap: _leyoTodo ? () => setState(() => _acepto = !_acepto) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _acepto ? AppColors.green.withOpacity(0.1) : AppColors.white05,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _acepto ? AppColors.green : (_leyoTodo ? AppColors.white30 : AppColors.white10),
                        width: _acepto ? 1.5 : 1,
                      ),
                    ),
                    child: Row(children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: _acepto ? AppColors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _acepto ? AppColors.green : (_leyoTodo ? AppColors.white30 : AppColors.white10),
                            width: 2,
                          ),
                        ),
                        child: _acepto
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Acepto los términos y condiciones',
                          style: GoogleFonts.barlowCondensed(fontSize: 15, fontWeight: FontWeight.w600,
                            color: _leyoTodo ? Colors.white : AppColors.white30)),
                        if (!_leyoTodo)
                          Text('Terminá de leer el contrato para habilitar esta opción',
                            style: GoogleFonts.barlow(fontSize: 11, color: AppColors.white30)),
                      ])),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón aceptar y continuar
                ElevatedButton(
                  onPressed: (_acepto && !_guardando) ? _aceptarYContinuar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.white05,
                    disabledForegroundColor: AppColors.white30,
                  ),
                  child: _guardando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.check_circle_outline, size: 18),
                          const SizedBox(width: 8),
                          Text('ACEPTAR Y CONTINUAR',
                            style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2)),
                        ]),
                ),
                const SizedBox(height: 8),

                // Botón rechazar
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Center(child: Text('No acepto, volver atrás',
                    style: GoogleFonts.barlowCondensed(fontSize: 14, color: AppColors.white30))),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ])),
      ]),
    );
  }

  Widget _clausula(String numero, String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.blueBright.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(numero,
              style: GoogleFonts.bebasNeue(fontSize: 14, color: AppColors.blueBright))),
          ),
          const SizedBox(width: 10),
          Text(titulo,
            style: GoogleFonts.barlowCondensed(fontSize: 14, fontWeight: FontWeight.w700,
              letterSpacing: 1, color: Colors.white)),
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white05,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.white10),
          ),
          child: Text(texto,
            style: GoogleFonts.barlow(fontSize: 13, color: AppColors.white30, height: 1.6)),
        ),
      ]),
    );
  }
}