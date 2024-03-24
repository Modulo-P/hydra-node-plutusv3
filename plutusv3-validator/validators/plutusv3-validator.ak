use aiken/builtin.{bytearray_to_integer}
use aiken/string.{from_int}
use aiken/transaction.{OutputReference, ScriptContext, Spend, TransactionId}

 
validator {
  fn plutusv3_validator(
    _datum: Void,
    redeemer: Int,
    _context: ScriptContext,
  ) -> Bool {
    trace from_int(bytearray_to_integer(True, #[42]))
    bytearray_to_integer(True, #[42]) == redeemer
  }
}


test plutusv3_validator_test() {
   let datum = Void
 
  let redeemer = 42
 
  let placeholder_utxo =
    OutputReference { transaction_id: TransactionId(""), output_index: 0 }
 
  let context =
    ScriptContext {
      purpose: Spend(placeholder_utxo),
      transaction: transaction.placeholder(),
    }
 
  plutusv3_validator(datum, redeemer, context)

}