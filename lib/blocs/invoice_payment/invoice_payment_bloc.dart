import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/invoice_payment_model.dart';
import 'package:kampus/services/invoice_payment_service.dart';

part 'invoice_payment_event.dart';
part 'invoice_payment_state.dart';

class InvoicePaymentBloc
    extends Bloc<InvoicePaymentEvent, InvoicePaymentState> {
  InvoicePaymentBloc() : super(InvoicePaymentInitial()) {
    on<InvoicePaymentEvent>((event, emit) async {
      if (event is InvoicePaymentGet) {
        try {
          emit(InvoicePaymentLoading());

          final krs = await InvoicePaymentService().getInvoicePayment();
          emit(InvoicePaymentSuccess(krs));
        } catch (e) {
          emit(InvoicePaymentFailed(e.toString()));
        }
      }
    });
  }
}
