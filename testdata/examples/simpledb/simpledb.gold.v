(* autogenerated from github.com/tchajed/goose/testdata/examples/simpledb *)
From New.golang Require Import defn.
From New.code Require github_com.tchajed.goose.machine.
From New.code Require github_com.tchajed.goose.machine.filesys.
From New.code Require github_com.tchajed.marshal.
From New.code Require sync.

Section code.
Context `{ffi_syntax}.
Local Coercion Var' s: expr := Var s.

Definition UseMarshal : val :=
  rec: "UseMarshal" <> :=
    exception_do (do:  marshal.NewEnc #0;;;
    do:  #()).

Definition Table : go_type := structT [
  "Index" :: mapT uint64T uint64T;
  "File" :: fileT
].

Definition Table__mset : list (string * val) := [
].

(* CreateTable creates a new, empty table. *)
Definition CreateTable : val :=
  rec: "CreateTable" "p" :=
    exception_do (let: "p" := ref_ty stringT "p" in
    let: "index" := ref_ty (mapT uint64T uint64T) (zero_val (mapT uint64T uint64T)) in
    let: "$a0" := map.make uint64T uint64T #() in
    do:  "index" <-[mapT uint64T uint64T] "$a0";;;
    let: <> := ref_ty boolT (zero_val boolT) in
    let: "f" := ref_ty fileT (zero_val fileT) in
    let: ("$a0", "$a1") := FS.Create #(str "db") (![stringT] "p") in
    do:  "$a1";;;
    do:  "f" <-[fileT] "$a0";;;
    do:  FS.Close (![fileT] "f");;;
    let: "f2" := ref_ty fileT (zero_val fileT) in
    let: "$a0" := FS.Open #(str "db") (![stringT] "p") in
    do:  "f2" <-[fileT] "$a0";;;
    return: (struct.make Table [{
       "Index" ::= ![mapT uint64T uint64T] "index";
       "File" ::= ![fileT] "f2"
     }]);;;
    do:  #()).

Definition Entry : go_type := structT [
  "Key" :: uint64T;
  "Value" :: sliceT byteT
].

Definition Entry__mset : list (string * val) := [
].

(* DecodeUInt64 is a Decoder(uint64)

   All decoders have the shape func(p []byte) (T, uint64)

   The uint64 represents the number of bytes consumed; if 0,
   then decoding failed, and the value of type T should be ignored. *)
Definition DecodeUInt64 : val :=
  rec: "DecodeUInt64" "p" :=
    exception_do (let: "p" := ref_ty (sliceT byteT) "p" in
    (if: (slice.len (![sliceT byteT] "p")) < #8
    then
      return: (#0, #0);;;
      do:  #()
    else do:  #());;;
    let: "n" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := machine.UInt64Get (![sliceT byteT] "p") in
    do:  "n" <-[uint64T] "$a0";;;
    return: (![uint64T] "n", #8);;;
    do:  #()).

(* DecodeEntry is a Decoder(Entry) *)
Definition DecodeEntry : val :=
  rec: "DecodeEntry" "data" :=
    exception_do (let: "data" := ref_ty (sliceT byteT) "data" in
    let: "l1" := ref_ty uint64T (zero_val uint64T) in
    let: "key" := ref_ty uint64T (zero_val uint64T) in
    let: ("$a0", "$a1") := DecodeUInt64 (![sliceT byteT] "data") in
    do:  "l1" <-[uint64T] "$a1";;;
    do:  "key" <-[uint64T] "$a0";;;
    (if: (![uint64T] "l1") = #0
    then
      return: (struct.make Entry [{
         "Key" ::= #0;
         "Value" ::= slice.nil
       }], #0);;;
      do:  #()
    else do:  #());;;
    let: "l2" := ref_ty uint64T (zero_val uint64T) in
    let: "valueLen" := ref_ty uint64T (zero_val uint64T) in
    let: ("$a0", "$a1") := DecodeUInt64 (let: "$s" := ![sliceT byteT] "data" in
    slice.slice byteT "$s" (![uint64T] "l1") (slice.len "$s")) in
    do:  "l2" <-[uint64T] "$a1";;;
    do:  "valueLen" <-[uint64T] "$a0";;;
    (if: (![uint64T] "l2") = #0
    then
      return: (struct.make Entry [{
         "Key" ::= #0;
         "Value" ::= slice.nil
       }], #0);;;
      do:  #()
    else do:  #());;;
    (if: (slice.len (![sliceT byteT] "data")) < (((![uint64T] "l1") + (![uint64T] "l2")) + (![uint64T] "valueLen"))
    then
      return: (struct.make Entry [{
         "Key" ::= #0;
         "Value" ::= slice.nil
       }], #0);;;
      do:  #()
    else do:  #());;;
    let: "value" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := let: "$s" := ![sliceT byteT] "data" in
    slice.slice byteT "$s" ((![uint64T] "l1") + (![uint64T] "l2")) (((![uint64T] "l1") + (![uint64T] "l2")) + (![uint64T] "valueLen")) in
    do:  "value" <-[sliceT byteT] "$a0";;;
    return: (struct.make Entry [{
       "Key" ::= ![uint64T] "key";
       "Value" ::= ![sliceT byteT] "value"
     }], ((![uint64T] "l1") + (![uint64T] "l2")) + (![uint64T] "valueLen"));;;
    do:  #()).

Definition lazyFileBuf : go_type := structT [
  "offset" :: uint64T;
  "next" :: sliceT byteT
].

Definition lazyFileBuf__mset : list (string * val) := [
].

(* readTableIndex parses a complete table on disk into a key->offset index *)
Definition readTableIndex : val :=
  rec: "readTableIndex" "f" "index" :=
    exception_do (let: "index" := ref_ty (mapT uint64T uint64T) "index" in
    let: "f" := ref_ty fileT "f" in
    (let: "buf" := ref_ty lazyFileBuf (zero_val lazyFileBuf) in
    let: "$a0" := struct.make lazyFileBuf [{
      "offset" ::= #0;
      "next" ::= slice.nil
    }] in
    do:  "buf" <-[lazyFileBuf] "$a0";;;
    (for: (λ: <>, #true); (λ: <>, Skip) := λ: <>,
      let: "l" := ref_ty uint64T (zero_val uint64T) in
      let: "e" := ref_ty Entry (zero_val Entry) in
      let: ("$a0", "$a1") := DecodeEntry (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")) in
      do:  "l" <-[uint64T] "$a1";;;
      do:  "e" <-[Entry] "$a0";;;
      (if: (![uint64T] "l") > #0
      then
        let: "$a0" := #8 + (![uint64T] (struct.field_ref lazyFileBuf "offset" "buf")) in
        do:  map.insert (![mapT uint64T uint64T] "index") (![uint64T] (struct.field_ref Entry "Key" "e")) "$a0";;;
        let: "$a0" := struct.make lazyFileBuf [{
          "offset" ::= (![uint64T] (struct.field_ref lazyFileBuf "offset" "buf")) + (![uint64T] "l");
          "next" ::= let: "$s" := ![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf") in
          slice.slice byteT "$s" (![uint64T] "l") (slice.len "$s")
        }] in
        do:  "buf" <-[lazyFileBuf] "$a0";;;
        continue: #();;;
        do:  #()
      else
        let: "p" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
        let: "$a0" := FS.ReadAt (![fileT] "f") ((![uint64T] (struct.field_ref lazyFileBuf "offset" "buf")) + (slice.len (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")))) #4096 in
        do:  "p" <-[sliceT byteT] "$a0";;;
        (if: (slice.len (![sliceT byteT] "p")) = #0
        then
          break: #();;;
          do:  #()
        else
          let: "newBuf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
          let: "$a0" := slice.append byteT (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")) (![sliceT byteT] "p") in
          do:  "newBuf" <-[sliceT byteT] "$a0";;;
          let: "$a0" := struct.make lazyFileBuf [{
            "offset" ::= ![uint64T] (struct.field_ref lazyFileBuf "offset" "buf");
            "next" ::= ![sliceT byteT] "newBuf"
          }] in
          do:  "buf" <-[lazyFileBuf] "$a0";;;
          continue: #();;;
          do:  #());;;
        do:  #());;;
      do:  #()));;;
    do:  #()).

(* RecoverTable restores a table from disk on startup. *)
Definition RecoverTable : val :=
  rec: "RecoverTable" "p" :=
    exception_do (let: "p" := ref_ty stringT "p" in
    let: "index" := ref_ty (mapT uint64T uint64T) (zero_val (mapT uint64T uint64T)) in
    let: "$a0" := map.make uint64T uint64T #() in
    do:  "index" <-[mapT uint64T uint64T] "$a0";;;
    let: "f" := ref_ty fileT (zero_val fileT) in
    let: "$a0" := FS.Open #(str "db") (![stringT] "p") in
    do:  "f" <-[fileT] "$a0";;;
    do:  readTableIndex (![fileT] "f") (![mapT uint64T uint64T] "index");;;
    return: (struct.make Table [{
       "Index" ::= ![mapT uint64T uint64T] "index";
       "File" ::= ![fileT] "f"
     }]);;;
    do:  #()).

(* CloseTable frees up the fd held by a table. *)
Definition CloseTable : val :=
  rec: "CloseTable" "t" :=
    exception_do (let: "t" := ref_ty Table "t" in
    do:  FS.Close (![fileT] (struct.field_ref Table "File" "t"));;;
    do:  #()).

Definition readValue : val :=
  rec: "readValue" "f" "off" :=
    exception_do (let: "off" := ref_ty uint64T "off" in
    let: "f" := ref_ty fileT "f" in
    let: "startBuf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := FS.ReadAt (![fileT] "f") (![uint64T] "off") #512 in
    do:  "startBuf" <-[sliceT byteT] "$a0";;;
    let: "totalBytes" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := machine.UInt64Get (![sliceT byteT] "startBuf") in
    do:  "totalBytes" <-[uint64T] "$a0";;;
    let: "buf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := let: "$s" := ![sliceT byteT] "startBuf" in
    slice.slice byteT "$s" #8 (slice.len "$s") in
    do:  "buf" <-[sliceT byteT] "$a0";;;
    let: "haveBytes" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := slice.len (![sliceT byteT] "buf") in
    do:  "haveBytes" <-[uint64T] "$a0";;;
    (if: (![uint64T] "haveBytes") < (![uint64T] "totalBytes")
    then
      let: "buf2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
      let: "$a0" := FS.ReadAt (![fileT] "f") ((![uint64T] "off") + #512) ((![uint64T] "totalBytes") - (![uint64T] "haveBytes")) in
      do:  "buf2" <-[sliceT byteT] "$a0";;;
      let: "newBuf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
      let: "$a0" := slice.append byteT (![sliceT byteT] "buf") (![sliceT byteT] "buf2") in
      do:  "newBuf" <-[sliceT byteT] "$a0";;;
      return: (![sliceT byteT] "newBuf");;;
      do:  #()
    else do:  #());;;
    return: (let: "$s" := ![sliceT byteT] "buf" in
     slice.slice byteT "$s" #0 (![uint64T] "totalBytes"));;;
    do:  #()).

Definition tableRead : val :=
  rec: "tableRead" "t" "k" :=
    exception_do (let: "k" := ref_ty uint64T "k" in
    let: "t" := ref_ty Table "t" in
    let: "ok" := ref_ty boolT (zero_val boolT) in
    let: "off" := ref_ty uint64T (zero_val uint64T) in
    let: ("$a0", "$a1") := Fst (map.get (![mapT uint64T uint64T] (struct.field_ref Table "Index" "t")) (![uint64T] "k")) in
    do:  "ok" <-[boolT] "$a1";;;
    do:  "off" <-[uint64T] "$a0";;;
    (if: (~ (![boolT] "ok"))
    then
      return: (slice.nil, #false);;;
      do:  #()
    else do:  #());;;
    let: "p" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := readValue (![fileT] (struct.field_ref Table "File" "t")) (![uint64T] "off") in
    do:  "p" <-[sliceT byteT] "$a0";;;
    return: (![sliceT byteT] "p", #true);;;
    do:  #()).

Definition bufFile : go_type := structT [
  "file" :: fileT;
  "buf" :: ptrT
].

Definition bufFile__mset : list (string * val) := [
].

Definition newBuf : val :=
  rec: "newBuf" "f" :=
    exception_do (let: "f" := ref_ty fileT "f" in
    let: "buf" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    do:  "buf" <-[ptrT] "$a0";;;
    return: (struct.make bufFile [{
       "file" ::= ![fileT] "f";
       "buf" ::= ![ptrT] "buf"
     }]);;;
    do:  #()).

Definition bufFlush : val :=
  rec: "bufFlush" "f" :=
    exception_do (let: "f" := ref_ty bufFile "f" in
    let: "buf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := ![sliceT byteT] (![ptrT] (struct.field_ref bufFile "buf" "f")) in
    do:  "buf" <-[sliceT byteT] "$a0";;;
    (if: (slice.len (![sliceT byteT] "buf")) = #0
    then
      return: (#());;;
      do:  #()
    else do:  #());;;
    do:  FS.Append (![fileT] (struct.field_ref bufFile "file" "f")) (![sliceT byteT] "buf");;;
    let: "$a0" := slice.nil in
    do:  (![ptrT] (struct.field_ref bufFile "buf" "f")) <-[sliceT byteT] "$a0";;;
    do:  #()).

Definition bufAppend : val :=
  rec: "bufAppend" "f" "p" :=
    exception_do (let: "p" := ref_ty (sliceT byteT) "p" in
    let: "f" := ref_ty bufFile "f" in
    let: "buf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := ![sliceT byteT] (![ptrT] (struct.field_ref bufFile "buf" "f")) in
    do:  "buf" <-[sliceT byteT] "$a0";;;
    let: "buf2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := slice.append byteT (![sliceT byteT] "buf") (![sliceT byteT] "p") in
    do:  "buf2" <-[sliceT byteT] "$a0";;;
    let: "$a0" := ![sliceT byteT] "buf2" in
    do:  (![ptrT] (struct.field_ref bufFile "buf" "f")) <-[sliceT byteT] "$a0";;;
    do:  #()).

Definition bufClose : val :=
  rec: "bufClose" "f" :=
    exception_do (let: "f" := ref_ty bufFile "f" in
    do:  bufFlush (![bufFile] "f");;;
    do:  FS.Close (![fileT] (struct.field_ref bufFile "file" "f"));;;
    do:  #()).

Definition tableWriter : go_type := structT [
  "index" :: mapT uint64T uint64T;
  "name" :: stringT;
  "file" :: bufFile;
  "offset" :: ptrT
].

Definition tableWriter__mset : list (string * val) := [
].

Definition newTableWriter : val :=
  rec: "newTableWriter" "p" :=
    exception_do (let: "p" := ref_ty stringT "p" in
    let: "index" := ref_ty (mapT uint64T uint64T) (zero_val (mapT uint64T uint64T)) in
    let: "$a0" := map.make uint64T uint64T #() in
    do:  "index" <-[mapT uint64T uint64T] "$a0";;;
    let: <> := ref_ty boolT (zero_val boolT) in
    let: "f" := ref_ty fileT (zero_val fileT) in
    let: ("$a0", "$a1") := FS.Create #(str "db") (![stringT] "p") in
    do:  "$a1";;;
    do:  "f" <-[fileT] "$a0";;;
    let: "buf" := ref_ty bufFile (zero_val bufFile) in
    let: "$a0" := newBuf (![fileT] "f") in
    do:  "buf" <-[bufFile] "$a0";;;
    let: "off" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty uint64T (zero_val uint64T) in
    do:  "off" <-[ptrT] "$a0";;;
    return: (struct.make tableWriter [{
       "index" ::= ![mapT uint64T uint64T] "index";
       "name" ::= ![stringT] "p";
       "file" ::= ![bufFile] "buf";
       "offset" ::= ![ptrT] "off"
     }]);;;
    do:  #()).

Definition tableWriterAppend : val :=
  rec: "tableWriterAppend" "w" "p" :=
    exception_do (let: "p" := ref_ty (sliceT byteT) "p" in
    let: "w" := ref_ty tableWriter "w" in
    do:  bufAppend (![bufFile] (struct.field_ref tableWriter "file" "w")) (![sliceT byteT] "p");;;
    let: "off" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := ![uint64T] (![ptrT] (struct.field_ref tableWriter "offset" "w")) in
    do:  "off" <-[uint64T] "$a0";;;
    let: "$a0" := (![uint64T] "off") + (slice.len (![sliceT byteT] "p")) in
    do:  (![ptrT] (struct.field_ref tableWriter "offset" "w")) <-[uint64T] "$a0";;;
    do:  #()).

Definition tableWriterClose : val :=
  rec: "tableWriterClose" "w" :=
    exception_do (let: "w" := ref_ty tableWriter "w" in
    do:  bufClose (![bufFile] (struct.field_ref tableWriter "file" "w"));;;
    let: "f" := ref_ty fileT (zero_val fileT) in
    let: "$a0" := FS.Open #(str "db") (![stringT] (struct.field_ref tableWriter "name" "w")) in
    do:  "f" <-[fileT] "$a0";;;
    return: (struct.make Table [{
       "Index" ::= ![mapT uint64T uint64T] (struct.field_ref tableWriter "index" "w");
       "File" ::= ![fileT] "f"
     }]);;;
    do:  #()).

(* EncodeUInt64 is an Encoder(uint64) *)
Definition EncodeUInt64 : val :=
  rec: "EncodeUInt64" "x" "p" :=
    exception_do (let: "p" := ref_ty (sliceT byteT) "p" in
    let: "x" := ref_ty uint64T "x" in
    let: "tmp" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := slice.make2 byteT #8 in
    do:  "tmp" <-[sliceT byteT] "$a0";;;
    do:  machine.UInt64Put (![sliceT byteT] "tmp") (![uint64T] "x");;;
    let: "p2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := slice.append byteT (![sliceT byteT] "p") (![sliceT byteT] "tmp") in
    do:  "p2" <-[sliceT byteT] "$a0";;;
    return: (![sliceT byteT] "p2");;;
    do:  #()).

(* EncodeSlice is an Encoder([]byte) *)
Definition EncodeSlice : val :=
  rec: "EncodeSlice" "data" "p" :=
    exception_do (let: "p" := ref_ty (sliceT byteT) "p" in
    let: "data" := ref_ty (sliceT byteT) "data" in
    let: "p2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := EncodeUInt64 (slice.len (![sliceT byteT] "data")) (![sliceT byteT] "p") in
    do:  "p2" <-[sliceT byteT] "$a0";;;
    let: "p3" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := slice.append byteT (![sliceT byteT] "p2") (![sliceT byteT] "data") in
    do:  "p3" <-[sliceT byteT] "$a0";;;
    return: (![sliceT byteT] "p3");;;
    do:  #()).

Definition tablePut : val :=
  rec: "tablePut" "w" "k" "v" :=
    exception_do (let: "v" := ref_ty (sliceT byteT) "v" in
    let: "k" := ref_ty uint64T "k" in
    let: "w" := ref_ty tableWriter "w" in
    let: "tmp" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := slice.make2 byteT #0 in
    do:  "tmp" <-[sliceT byteT] "$a0";;;
    let: "tmp2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := EncodeUInt64 (![uint64T] "k") (![sliceT byteT] "tmp") in
    do:  "tmp2" <-[sliceT byteT] "$a0";;;
    let: "tmp3" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := EncodeSlice (![sliceT byteT] "v") (![sliceT byteT] "tmp2") in
    do:  "tmp3" <-[sliceT byteT] "$a0";;;
    let: "off" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := ![uint64T] (![ptrT] (struct.field_ref tableWriter "offset" "w")) in
    do:  "off" <-[uint64T] "$a0";;;
    let: "$a0" := (![uint64T] "off") + (slice.len (![sliceT byteT] "tmp2")) in
    do:  map.insert (![mapT uint64T uint64T] (struct.field_ref tableWriter "index" "w")) (![uint64T] "k") "$a0";;;
    do:  tableWriterAppend (![tableWriter] "w") (![sliceT byteT] "tmp3");;;
    do:  #()).

Definition Database : go_type := structT [
  "wbuffer" :: ptrT;
  "rbuffer" :: ptrT;
  "bufferL" :: ptrT;
  "table" :: ptrT;
  "tableName" :: ptrT;
  "tableL" :: ptrT;
  "compactionL" :: ptrT
].

Definition Database__mset : list (string * val) := [
].

Definition makeValueBuffer : val :=
  rec: "makeValueBuffer" <> :=
    exception_do (let: "buf" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := map.make uint64T (sliceT byteT) #() in
    do:  "buf" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "bufPtr" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    do:  "bufPtr" <-[ptrT] "$a0";;;
    let: "$a0" := ![mapT uint64T (sliceT byteT)] "buf" in
    do:  (![ptrT] "bufPtr") <-[mapT uint64T (sliceT byteT)] "$a0";;;
    return: (![ptrT] "bufPtr");;;
    do:  #()).

(* NewDb initializes a new database on top of an empty filesys. *)
Definition NewDb : val :=
  rec: "NewDb" <> :=
    exception_do (let: "wbuf" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := makeValueBuffer #() in
    do:  "wbuf" <-[ptrT] "$a0";;;
    let: "rbuf" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := makeValueBuffer #() in
    do:  "rbuf" <-[ptrT] "$a0";;;
    let: "bufferL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "bufferL" <-[ptrT] "$a0";;;
    let: "tableName" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := #(str "table.0") in
    do:  "tableName" <-[stringT] "$a0";;;
    let: "tableNameRef" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty stringT (zero_val stringT) in
    do:  "tableNameRef" <-[ptrT] "$a0";;;
    let: "$a0" := ![stringT] "tableName" in
    do:  (![ptrT] "tableNameRef") <-[stringT] "$a0";;;
    let: "table" := ref_ty Table (zero_val Table) in
    let: "$a0" := CreateTable (![stringT] "tableName") in
    do:  "table" <-[Table] "$a0";;;
    let: "tableRef" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty Table (zero_val Table) in
    do:  "tableRef" <-[ptrT] "$a0";;;
    let: "$a0" := ![Table] "table" in
    do:  (![ptrT] "tableRef") <-[Table] "$a0";;;
    let: "tableL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "tableL" <-[ptrT] "$a0";;;
    let: "compactionL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "compactionL" <-[ptrT] "$a0";;;
    return: (struct.make Database [{
       "wbuffer" ::= ![ptrT] "wbuf";
       "rbuffer" ::= ![ptrT] "rbuf";
       "bufferL" ::= ![ptrT] "bufferL";
       "table" ::= ![ptrT] "tableRef";
       "tableName" ::= ![ptrT] "tableNameRef";
       "tableL" ::= ![ptrT] "tableL";
       "compactionL" ::= ![ptrT] "compactionL"
     }]);;;
    do:  #()).

(* Read gets a key from the database.

   Returns a boolean indicating if the k was found and a non-nil slice with
   the value if k was in the database.

   Reflects any completed in-memory writes. *)
Definition Read : val :=
  rec: "Read" "db" "k" :=
    exception_do (let: "k" := ref_ty uint64T "k" in
    let: "db" := ref_ty Database "db" in
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    let: "buf" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := ![mapT uint64T (sliceT byteT)] (![ptrT] (struct.field_ref Database "wbuffer" "db")) in
    do:  "buf" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "ok" := ref_ty boolT (zero_val boolT) in
    let: "v" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: ("$a0", "$a1") := Fst (map.get (![mapT uint64T (sliceT byteT)] "buf") (![uint64T] "k")) in
    do:  "ok" <-[boolT] "$a1";;;
    do:  "v" <-[sliceT byteT] "$a0";;;
    (if: ![boolT] "ok"
    then
      do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
      return: (![sliceT byteT] "v", #true);;;
      do:  #()
    else do:  #());;;
    let: "rbuf" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := ![mapT uint64T (sliceT byteT)] (![ptrT] (struct.field_ref Database "rbuffer" "db")) in
    do:  "rbuf" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "v2" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: ("$a0", "$a1") := Fst (map.get (![mapT uint64T (sliceT byteT)] "rbuf") (![uint64T] "k")) in
    do:  "ok" <-[boolT] "$a1";;;
    do:  "v2" <-[sliceT byteT] "$a0";;;
    (if: ![boolT] "ok"
    then
      do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
      return: (![sliceT byteT] "v2", #true);;;
      do:  #()
    else do:  #());;;
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "tableL" "db"))) #();;;
    let: "tbl" := ref_ty Table (zero_val Table) in
    let: "$a0" := ![Table] (![ptrT] (struct.field_ref Database "table" "db")) in
    do:  "tbl" <-[Table] "$a0";;;
    let: "v3" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: ("$a0", "$a1") := tableRead (![Table] "tbl") (![uint64T] "k") in
    do:  "ok" <-[boolT] "$a1";;;
    do:  "v3" <-[sliceT byteT] "$a0";;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "tableL" "db"))) #();;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    return: (![sliceT byteT] "v3", ![boolT] "ok");;;
    do:  #()).

(* Write sets a key to a new value.

   Creates a new key-value mapping if k is not in the database and overwrites
   the previous value if k is present.

   The new value is buffered in memory. To persist it, call db.Compact(). *)
Definition Write : val :=
  rec: "Write" "db" "k" "v" :=
    exception_do (let: "v" := ref_ty (sliceT byteT) "v" in
    let: "k" := ref_ty uint64T "k" in
    let: "db" := ref_ty Database "db" in
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    let: "buf" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := ![mapT uint64T (sliceT byteT)] (![ptrT] (struct.field_ref Database "wbuffer" "db")) in
    do:  "buf" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "$a0" := ![sliceT byteT] "v" in
    do:  map.insert (![mapT uint64T (sliceT byteT)] "buf") (![uint64T] "k") "$a0";;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    do:  #()).

Definition freshTable : val :=
  rec: "freshTable" "p" :=
    exception_do (let: "p" := ref_ty stringT "p" in
    (if: (![stringT] "p") = #(str "table.0")
    then
      return: (#(str "table.1"));;;
      do:  #()
    else do:  #());;;
    (if: (![stringT] "p") = #(str "table.1")
    then
      return: (#(str "table.0"));;;
      do:  #()
    else do:  #());;;
    return: (![stringT] "p");;;
    do:  #()).

Definition tablePutBuffer : val :=
  rec: "tablePutBuffer" "w" "buf" :=
    exception_do (let: "buf" := ref_ty (mapT uint64T (sliceT byteT)) "buf" in
    let: "w" := ref_ty tableWriter "w" in
    do:  MapIter (![mapT uint64T (sliceT byteT)] "buf") (λ: "k" "v",
      do:  tablePut (![tableWriter] "w") (![uint64T] "k") (![sliceT byteT] "v");;;
      do:  #());;;
    do:  #()).

(* add all of table t to the table w being created; skip any keys in the (read)
   buffer b since those writes overwrite old ones *)
Definition tablePutOldTable : val :=
  rec: "tablePutOldTable" "w" "t" "b" :=
    exception_do (let: "b" := ref_ty (mapT uint64T (sliceT byteT)) "b" in
    let: "t" := ref_ty Table "t" in
    let: "w" := ref_ty tableWriter "w" in
    (let: "buf" := ref_ty lazyFileBuf (zero_val lazyFileBuf) in
    let: "$a0" := struct.make lazyFileBuf [{
      "offset" ::= #0;
      "next" ::= slice.nil
    }] in
    do:  "buf" <-[lazyFileBuf] "$a0";;;
    (for: (λ: <>, #true); (λ: <>, Skip) := λ: <>,
      let: "l" := ref_ty uint64T (zero_val uint64T) in
      let: "e" := ref_ty Entry (zero_val Entry) in
      let: ("$a0", "$a1") := DecodeEntry (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")) in
      do:  "l" <-[uint64T] "$a1";;;
      do:  "e" <-[Entry] "$a0";;;
      (if: (![uint64T] "l") > #0
      then
        let: "ok" := ref_ty boolT (zero_val boolT) in
        let: <> := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
        let: ("$a0", "$a1") := Fst (map.get (![mapT uint64T (sliceT byteT)] "b") (![uint64T] (struct.field_ref Entry "Key" "e"))) in
        do:  "ok" <-[boolT] "$a1";;;
        do:  "$a0";;;
        (if: (~ (![boolT] "ok"))
        then
          do:  tablePut (![tableWriter] "w") (![uint64T] (struct.field_ref Entry "Key" "e")) (![sliceT byteT] (struct.field_ref Entry "Value" "e"));;;
          do:  #()
        else do:  #());;;
        let: "$a0" := struct.make lazyFileBuf [{
          "offset" ::= (![uint64T] (struct.field_ref lazyFileBuf "offset" "buf")) + (![uint64T] "l");
          "next" ::= let: "$s" := ![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf") in
          slice.slice byteT "$s" (![uint64T] "l") (slice.len "$s")
        }] in
        do:  "buf" <-[lazyFileBuf] "$a0";;;
        continue: #();;;
        do:  #()
      else
        let: "p" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
        let: "$a0" := FS.ReadAt (![fileT] (struct.field_ref Table "File" "t")) ((![uint64T] (struct.field_ref lazyFileBuf "offset" "buf")) + (slice.len (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")))) #4096 in
        do:  "p" <-[sliceT byteT] "$a0";;;
        (if: (slice.len (![sliceT byteT] "p")) = #0
        then
          break: #();;;
          do:  #()
        else
          let: "newBuf" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
          let: "$a0" := slice.append byteT (![sliceT byteT] (struct.field_ref lazyFileBuf "next" "buf")) (![sliceT byteT] "p") in
          do:  "newBuf" <-[sliceT byteT] "$a0";;;
          let: "$a0" := struct.make lazyFileBuf [{
            "offset" ::= ![uint64T] (struct.field_ref lazyFileBuf "offset" "buf");
            "next" ::= ![sliceT byteT] "newBuf"
          }] in
          do:  "buf" <-[lazyFileBuf] "$a0";;;
          continue: #();;;
          do:  #());;;
        do:  #());;;
      do:  #()));;;
    do:  #()).

(* Build a new shadow table that incorporates the current table and a
   (write) buffer wbuf.

   Assumes all the appropriate locks have been taken.

   Returns the old table and new table. *)
Definition constructNewTable : val :=
  rec: "constructNewTable" "db" "wbuf" :=
    exception_do (let: "wbuf" := ref_ty (mapT uint64T (sliceT byteT)) "wbuf" in
    let: "db" := ref_ty Database "db" in
    let: "oldName" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := ![stringT] (![ptrT] (struct.field_ref Database "tableName" "db")) in
    do:  "oldName" <-[stringT] "$a0";;;
    let: "name" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := freshTable (![stringT] "oldName") in
    do:  "name" <-[stringT] "$a0";;;
    let: "w" := ref_ty tableWriter (zero_val tableWriter) in
    let: "$a0" := newTableWriter (![stringT] "name") in
    do:  "w" <-[tableWriter] "$a0";;;
    let: "oldTable" := ref_ty Table (zero_val Table) in
    let: "$a0" := ![Table] (![ptrT] (struct.field_ref Database "table" "db")) in
    do:  "oldTable" <-[Table] "$a0";;;
    do:  tablePutOldTable (![tableWriter] "w") (![Table] "oldTable") (![mapT uint64T (sliceT byteT)] "wbuf");;;
    do:  tablePutBuffer (![tableWriter] "w") (![mapT uint64T (sliceT byteT)] "wbuf");;;
    let: "newTable" := ref_ty Table (zero_val Table) in
    let: "$a0" := tableWriterClose (![tableWriter] "w") in
    do:  "newTable" <-[Table] "$a0";;;
    return: (![Table] "oldTable", ![Table] "newTable");;;
    do:  #()).

(* Compact persists in-memory writes to a new table.

   This simple database design must re-write all data to combine in-memory
   writes with existing writes. *)
Definition Compact : val :=
  rec: "Compact" "db" :=
    exception_do (let: "db" := ref_ty Database "db" in
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "compactionL" "db"))) #();;;
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    let: "buf" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := ![mapT uint64T (sliceT byteT)] (![ptrT] (struct.field_ref Database "wbuffer" "db")) in
    do:  "buf" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "emptyWbuffer" := ref_ty (mapT uint64T (sliceT byteT)) (zero_val (mapT uint64T (sliceT byteT))) in
    let: "$a0" := map.make uint64T (sliceT byteT) #() in
    do:  "emptyWbuffer" <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "$a0" := ![mapT uint64T (sliceT byteT)] "emptyWbuffer" in
    do:  (![ptrT] (struct.field_ref Database "wbuffer" "db")) <-[mapT uint64T (sliceT byteT)] "$a0";;;
    let: "$a0" := ![mapT uint64T (sliceT byteT)] "buf" in
    do:  (![ptrT] (struct.field_ref Database "rbuffer" "db")) <-[mapT uint64T (sliceT byteT)] "$a0";;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "tableL" "db"))) #();;;
    let: "oldTableName" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := ![stringT] (![ptrT] (struct.field_ref Database "tableName" "db")) in
    do:  "oldTableName" <-[stringT] "$a0";;;
    let: "t" := ref_ty Table (zero_val Table) in
    let: "oldTable" := ref_ty Table (zero_val Table) in
    let: ("$a0", "$a1") := constructNewTable (![Database] "db") (![mapT uint64T (sliceT byteT)] "buf") in
    do:  "t" <-[Table] "$a1";;;
    do:  "oldTable" <-[Table] "$a0";;;
    let: "newTable" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := freshTable (![stringT] "oldTableName") in
    do:  "newTable" <-[stringT] "$a0";;;
    let: "$a0" := ![Table] "t" in
    do:  (![ptrT] (struct.field_ref Database "table" "db")) <-[Table] "$a0";;;
    let: "$a0" := ![stringT] "newTable" in
    do:  (![ptrT] (struct.field_ref Database "tableName" "db")) <-[stringT] "$a0";;;
    let: "manifestData" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := StringToBytes (![stringT] "newTable") in
    do:  "manifestData" <-[sliceT byteT] "$a0";;;
    do:  FS.AtomicCreate #(str "db") #(str "manifest") (![sliceT byteT] "manifestData");;;
    do:  CloseTable (![Table] "oldTable");;;
    do:  FS.Delete #(str "db") (![stringT] "oldTableName");;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "tableL" "db"))) #();;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "compactionL" "db"))) #();;;
    do:  #()).

Definition recoverManifest : val :=
  rec: "recoverManifest" <> :=
    exception_do (let: "f" := ref_ty fileT (zero_val fileT) in
    let: "$a0" := FS.Open #(str "db") #(str "manifest") in
    do:  "f" <-[fileT] "$a0";;;
    let: "manifestData" := ref_ty (sliceT byteT) (zero_val (sliceT byteT)) in
    let: "$a0" := FS.ReadAt (![fileT] "f") #0 #4096 in
    do:  "manifestData" <-[sliceT byteT] "$a0";;;
    let: "tableName" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := StringFromBytes (![sliceT byteT] "manifestData") in
    do:  "tableName" <-[stringT] "$a0";;;
    do:  FS.Close (![fileT] "f");;;
    return: (![stringT] "tableName");;;
    do:  #()).

(* delete 'name' if it isn't tableName or "manifest" *)
Definition deleteOtherFile : val :=
  rec: "deleteOtherFile" "name" "tableName" :=
    exception_do (let: "tableName" := ref_ty stringT "tableName" in
    let: "name" := ref_ty stringT "name" in
    (if: (![stringT] "name") = (![stringT] "tableName")
    then
      return: (#());;;
      do:  #()
    else do:  #());;;
    (if: (![stringT] "name") = #(str "manifest")
    then
      return: (#());;;
      do:  #()
    else do:  #());;;
    do:  FS.Delete #(str "db") (![stringT] "name");;;
    do:  #()).

Definition deleteOtherFiles : val :=
  rec: "deleteOtherFiles" "tableName" :=
    exception_do (let: "tableName" := ref_ty stringT "tableName" in
    let: "files" := ref_ty (sliceT stringT) (zero_val (sliceT stringT)) in
    let: "$a0" := FS.List #(str "db") in
    do:  "files" <-[sliceT stringT] "$a0";;;
    let: "nfiles" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := slice.len (![sliceT stringT] "files") in
    do:  "nfiles" <-[uint64T] "$a0";;;
    (let: "i" := ref_ty uint64T (zero_val uint64T) in
    let: "$a0" := #0 in
    do:  "i" <-[uint64T] "$a0";;;
    (for: (λ: <>, #true); (λ: <>, Skip) := λ: <>,
      (if: (![uint64T] "i") = (![uint64T] "nfiles")
      then
        break: #();;;
        do:  #()
      else do:  #());;;
      let: "name" := ref_ty stringT (zero_val stringT) in
      let: "$a0" := ![stringT] (slice.elem_ref stringT (![sliceT stringT] "files") (![uint64T] "i")) in
      do:  "name" <-[stringT] "$a0";;;
      do:  deleteOtherFile (![stringT] "name") (![stringT] "tableName");;;
      let: "$a0" := (![uint64T] "i") + #1 in
      do:  "i" <-[uint64T] "$a0";;;
      continue: #();;;
      do:  #()));;;
    do:  #()).

(* Recover restores a previously created database after a crash or shutdown. *)
Definition Recover : val :=
  rec: "Recover" <> :=
    exception_do (let: "tableName" := ref_ty stringT (zero_val stringT) in
    let: "$a0" := recoverManifest #() in
    do:  "tableName" <-[stringT] "$a0";;;
    let: "table" := ref_ty Table (zero_val Table) in
    let: "$a0" := RecoverTable (![stringT] "tableName") in
    do:  "table" <-[Table] "$a0";;;
    let: "tableRef" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty Table (zero_val Table) in
    do:  "tableRef" <-[ptrT] "$a0";;;
    let: "$a0" := ![Table] "table" in
    do:  (![ptrT] "tableRef") <-[Table] "$a0";;;
    let: "tableNameRef" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty stringT (zero_val stringT) in
    do:  "tableNameRef" <-[ptrT] "$a0";;;
    let: "$a0" := ![stringT] "tableName" in
    do:  (![ptrT] "tableNameRef") <-[stringT] "$a0";;;
    do:  deleteOtherFiles (![stringT] "tableName");;;
    let: "wbuffer" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := makeValueBuffer #() in
    do:  "wbuffer" <-[ptrT] "$a0";;;
    let: "rbuffer" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := makeValueBuffer #() in
    do:  "rbuffer" <-[ptrT] "$a0";;;
    let: "bufferL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "bufferL" <-[ptrT] "$a0";;;
    let: "tableL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "tableL" <-[ptrT] "$a0";;;
    let: "compactionL" := ref_ty ptrT (zero_val ptrT) in
    let: "$a0" := ref_ty sync.Mutex (zero_val sync.Mutex) in
    do:  "compactionL" <-[ptrT] "$a0";;;
    return: (struct.make Database [{
       "wbuffer" ::= ![ptrT] "wbuffer";
       "rbuffer" ::= ![ptrT] "rbuffer";
       "bufferL" ::= ![ptrT] "bufferL";
       "table" ::= ![ptrT] "tableRef";
       "tableName" ::= ![ptrT] "tableNameRef";
       "tableL" ::= ![ptrT] "tableL";
       "compactionL" ::= ![ptrT] "compactionL"
     }]);;;
    do:  #()).

(* Shutdown immediately closes the database.

   Discards any uncommitted in-memory writes; similar to a crash except for
   cleanly closing any open files. *)
Definition Shutdown : val :=
  rec: "Shutdown" "db" :=
    exception_do (let: "db" := ref_ty Database "db" in
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    do:  (sync.Mutex__Lock (![ptrT] (struct.field_ref Database "compactionL" "db"))) #();;;
    let: "t" := ref_ty Table (zero_val Table) in
    let: "$a0" := ![Table] (![ptrT] (struct.field_ref Database "table" "db")) in
    do:  "t" <-[Table] "$a0";;;
    do:  CloseTable (![Table] "t");;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "compactionL" "db"))) #();;;
    do:  (sync.Mutex__Unlock (![ptrT] (struct.field_ref Database "bufferL" "db"))) #();;;
    do:  #()).

(* Close closes an open database cleanly, flushing any in-memory writes.

   db should not be used afterward *)
Definition Close : val :=
  rec: "Close" "db" :=
    exception_do (let: "db" := ref_ty Database "db" in
    do:  Compact (![Database] "db");;;
    do:  Shutdown (![Database] "db");;;
    do:  #()).

End code.
