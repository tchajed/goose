(* autogenerated from awol *)
From Perennial.goose_lang Require Import prelude.
From Perennial.goose_lang Require Import ffi.disk_prelude.

(* 10 is completely arbitrary *)
Definition MaxTxnWrites : expr := #10.
Theorem MaxTxnWrites_t Γ : Γ ⊢ MaxTxnWrites : uint64T.
Proof. typecheck. Qed.

Definition logLength : expr := #1 + #2 * MaxTxnWrites.
Theorem logLength_t Γ : Γ ⊢ logLength : uint64T.
Proof. typecheck. Qed.

Module Log.
  Definition S := struct.decl [
    "d" :: disk.Disk;
    "l" :: lockRefT;
    "cache" :: mapT disk.blockT;
    "length" :: refT uint64T
  ].
End Log.

Definition intToBlock: val :=
  rec: "intToBlock" "a" :=
    let: "b" := NewSlice byteT disk.BlockSize in
    UInt64Put "b" "a";;
    "b".
Theorem intToBlock_t: ⊢ intToBlock : (uint64T -> disk.blockT).
Proof. typecheck. Qed.
Hint Resolve intToBlock_t : types.

Definition blockToInt: val :=
  rec: "blockToInt" "v" :=
    let: "a" := UInt64Get "v" in
    "a".
Theorem blockToInt_t: ⊢ blockToInt : (disk.blockT -> uint64T).
Proof. typecheck. Qed.
Hint Resolve blockToInt_t : types.

(* New initializes a fresh log *)
Definition New: val :=
  rec: "New" <> :=
    let: "d" := disk.Get #() in
    let: "diskSize" := disk.Size #() in
    (if: "diskSize" ≤ logLength
    then
      Panic ("disk is too small to host log");;
      #()
    else #());;
    let: "cache" := NewMap disk.blockT in
    let: "header" := intToBlock #0 in
    disk.Write #0 "header";;
    let: "lengthPtr" := ref (zero_val uint64T) in
    "lengthPtr" <-[uint64T] #0;;
    let: "l" := lock.new #() in
    struct.mk Log.S [
      "d" ::= "d";
      "cache" ::= "cache";
      "length" ::= "lengthPtr";
      "l" ::= "l"
    ].
Theorem New_t: ⊢ New : (unitT -> struct.t Log.S).
Proof. typecheck. Qed.
Hint Resolve New_t : types.

Definition Log__lock: val :=
  rec: "Log__lock" "l" :=
    lock.acquire (struct.get Log.S "l" "l").
Theorem Log__lock_t: ⊢ Log__lock : (struct.t Log.S -> unitT).
Proof. typecheck. Qed.
Hint Resolve Log__lock_t : types.

Definition Log__unlock: val :=
  rec: "Log__unlock" "l" :=
    lock.release (struct.get Log.S "l" "l").
Theorem Log__unlock_t: ⊢ Log__unlock : (struct.t Log.S -> unitT).
Proof. typecheck. Qed.
Hint Resolve Log__unlock_t : types.

(* BeginTxn allocates space for a new transaction in the log.

   Returns true if the allocation succeeded. *)
Definition Log__BeginTxn: val :=
  rec: "Log__BeginTxn" "l" :=
    Log__lock "l";;
    let: "length" := ![uint64T] (struct.get Log.S "length" "l") in
    (if: ("length" = #0)
    then
      Log__unlock "l";;
      #true
    else
      Log__unlock "l";;
      #false).
Theorem Log__BeginTxn_t: ⊢ Log__BeginTxn : (struct.t Log.S -> boolT).
Proof. typecheck. Qed.
Hint Resolve Log__BeginTxn_t : types.

(* Read from the logical disk.

   Reads must go through the log to return committed but un-applied writes. *)
Definition Log__Read: val :=
  rec: "Log__Read" "l" "a" :=
    Log__lock "l";;
    let: ("v", "ok") := MapGet (struct.get Log.S "cache" "l") "a" in
    (if: "ok"
    then
      Log__unlock "l";;
      "v"
    else
      Log__unlock "l";;
      let: "dv" := disk.Read (logLength + "a") in
      "dv").
Theorem Log__Read_t: ⊢ Log__Read : (struct.t Log.S -> uint64T -> disk.blockT).
Proof. typecheck. Qed.
Hint Resolve Log__Read_t : types.

Definition Log__Size: val :=
  rec: "Log__Size" "l" :=
    let: "sz" := disk.Size #() in
    "sz" - logLength.
Theorem Log__Size_t: ⊢ Log__Size : (struct.t Log.S -> uint64T).
Proof. typecheck. Qed.
Hint Resolve Log__Size_t : types.

(* Write to the disk through the log. *)
Definition Log__Write: val :=
  rec: "Log__Write" "l" "a" "v" :=
    Log__lock "l";;
    let: "length" := ![uint64T] (struct.get Log.S "length" "l") in
    (if: "length" ≥ MaxTxnWrites
    then
      Panic ("transaction is at capacity");;
      #()
    else #());;
    let: "aBlock" := intToBlock "a" in
    let: "nextAddr" := #1 + #2 * "length" in
    disk.Write "nextAddr" "aBlock";;
    disk.Write ("nextAddr" + #1) "v";;
    MapInsert (struct.get Log.S "cache" "l") "a" "v";;
    struct.get Log.S "length" "l" <-[uint64T] "length" + #1;;
    Log__unlock "l".
Theorem Log__Write_t: ⊢ Log__Write : (struct.t Log.S -> uint64T -> disk.blockT -> unitT).
Proof. typecheck. Qed.
Hint Resolve Log__Write_t : types.

(* Commit the current transaction. *)
Definition Log__Commit: val :=
  rec: "Log__Commit" "l" :=
    Log__lock "l";;
    let: "length" := ![uint64T] (struct.get Log.S "length" "l") in
    Log__unlock "l";;
    let: "header" := intToBlock "length" in
    disk.Write #0 "header".
Theorem Log__Commit_t: ⊢ Log__Commit : (struct.t Log.S -> unitT).
Proof. typecheck. Qed.
Hint Resolve Log__Commit_t : types.

Definition getLogEntry: val :=
  rec: "getLogEntry" "d" "logOffset" :=
    let: "diskAddr" := #1 + #2 * "logOffset" in
    let: "aBlock" := disk.Read "diskAddr" in
    let: "a" := blockToInt "aBlock" in
    let: "v" := disk.Read ("diskAddr" + #1) in
    ("a", "v").
Theorem getLogEntry_t: ⊢ getLogEntry : (disk.Disk -> uint64T -> (uint64T * disk.blockT)).
Proof. typecheck. Qed.
Hint Resolve getLogEntry_t : types.

(* applyLog assumes we are running sequentially *)
Definition applyLog: val :=
  rec: "applyLog" "d" "length" :=
    let: "i" := ref_to uint64T #0 in
    (for: (λ: <>, #true); (λ: <>, Skip) := λ: <>,
      (if: ![uint64T] "i" < "length"
      then
        let: ("a", "v") := getLogEntry "d" (![uint64T] "i") in
        disk.Write (logLength + "a") "v";;
        "i" <-[uint64T] ![uint64T] "i" + #1;;
        Continue
      else Break)).
Theorem applyLog_t: ⊢ applyLog : (disk.Disk -> uint64T -> unitT).
Proof. typecheck. Qed.
Hint Resolve applyLog_t : types.

Definition clearLog: val :=
  rec: "clearLog" "d" :=
    let: "header" := intToBlock #0 in
    disk.Write #0 "header".
Theorem clearLog_t: ⊢ clearLog : (disk.Disk -> unitT).
Proof. typecheck. Qed.
Hint Resolve clearLog_t : types.

(* Apply all the committed transactions.

   Frees all the space in the log. *)
Definition Log__Apply: val :=
  rec: "Log__Apply" "l" :=
    Log__lock "l";;
    let: "length" := ![uint64T] (struct.get Log.S "length" "l") in
    applyLog (struct.get Log.S "d" "l") "length";;
    clearLog (struct.get Log.S "d" "l");;
    struct.get Log.S "length" "l" <-[uint64T] #0;;
    Log__unlock "l".
Theorem Log__Apply_t: ⊢ Log__Apply : (struct.t Log.S -> unitT).
Proof. typecheck. Qed.
Hint Resolve Log__Apply_t : types.

(* Open recovers the log following a crash or shutdown *)
Definition Open: val :=
  rec: "Open" <> :=
    let: "d" := disk.Get #() in
    let: "header" := disk.Read #0 in
    let: "length" := blockToInt "header" in
    applyLog "d" "length";;
    clearLog "d";;
    let: "cache" := NewMap disk.blockT in
    let: "lengthPtr" := ref (zero_val uint64T) in
    "lengthPtr" <-[uint64T] #0;;
    let: "l" := lock.new #() in
    struct.mk Log.S [
      "d" ::= "d";
      "cache" ::= "cache";
      "length" ::= "lengthPtr";
      "l" ::= "l"
    ].
Theorem Open_t: ⊢ Open : (unitT -> struct.t Log.S).
Proof. typecheck. Qed.
Hint Resolve Open_t : types.