# Pruebas de conocimiento nulo

## Definicion
Una prueba de conocimiento nulo es una tecnica criptografica que permite probar la validez de una hecho/declaracion (_statement_) sin revelar el _statement_ como tal. Existen dos partes en la prueba. 
- El "_prover_" el cual es el que trata de probar el hecho.
- El "_verifier_" el cual es el responsable de validar el hecho.

Cabe destacar que las 'pruebas' no son pruebas en el contexto matematico (probar un _statement_ mas alla de cualquier duda), si no que son pruebas probabilisticas. Es decir, se 'prueba' un _statement_ con un alto grado de certeza (generalmente la probabilidad de error es extremedamente baja).

Solo se podra generar una prueba de un _statement_ solo cuando se tenga posesion de cierta informacion secreta asociada al mismo (siendo esta la informacion que no se comparte). El _verifier_ no podra probar el _statement_ a otras partes, incluso despues de haberse convencido de que el _statement_ es verdadero. 

En general, para realizar una prueba de conocimiento nulo se necesita un protocolo en donde las dos partes interactuan; el _verifier_ propone _desafios_ aleatorios al _prover_ quien debe contestar correctamente. La naturaleza aleatoria de estos desafios, una vez resueltos correctamente por el _prover_, hacen que el _verifier_ acepte la 'prueba' de que el _statement_ es verdadero (se convence probabilistamente, con una probabilidad de falso positivo muy baja). Esta interaccion entre las partes hace que el _verifier_ no pueda hacerse pasar por el _prover_.

Una prueba de conocimiento nulo debe sastifacer los siguientes criterios:
- **Completitud**: Si el _input_ es valido, la prueba debe siempre retorar _verdadero_ (No debe existir la posibilidad de falsos negativos)
- **Robustez**: Si el _input_ es invalido, es teoricamente imposible engañar al protocolo de prueba de conocimiento nulo a retornar _verdadero_. (Un _prover_ mentiroso no puede hacer creer a un _verifier_ algo invalido, a excepcion de un margen de probabilidad pequeño)
- **Conocimiento nulo**: El _verifier_ aprende nada acerca del _statement_ excepto su validez. (Prevee que el _verifier_ derive el input original a partir de la prueba).

## Pruebas interactivas
Una prueba interactiva esta compuesta de tres elementos: 
- **Testigo**: El _prover_ quiere probar conocimiento de cierta informacion secreta. Esta informacion secreta es _testigo_ a la prueba y se asume que el _prover_ la conoce y puede responder ciertas preguntas a partir de esta. 
- **Desafio**: El _verifier_ elige al azar una pregunta (que puede ser respondida) y le pide al _prover_ que las responda
- **Respuesta**: El _prover_ acepta la respuesta y envia la respuesat al _verifier_. Esta respuesta da cierto grado de confianza de que el _prover_ realmente tiene conocimiento del _testigo_. Las repetidas realizaciones de este protocolo aumenta el grado de confianza hasta que el _verifier_ este lo suficientemente convencido (con una cantidad finita, sensible de _desafios_)

## Pruebas no interactivas
El problema de las pruebas interactivas es que el _prover_ debe convencer a todos los _verifiers_ realizando el mismo protocolo repetidas veces. Para evitar esto, las pruebas no interactivas se generan una sola vez; luego, cualquiera que quiera verificar que el _prover_ tiene la informacion secreta lo puede hacer. Para poder "recrear" la prueba se necesita una _shared key_ la cual fue usada al momento de crear la prueba, asi como el algoritmo de verificacion. 

## Pruebas interactivas de oraculo (_IOP_)
Un **oraculo* es una entidad abstracta que representa una maquina con conocimiento perfecto de la informacion. Ante una consulta, responde instantanea y/o correctamente a la misma, de manera deterministica. 

En una prueba interactiva de conocimiento nulo, el _prover_ actua como si fuera un oraculo (tiene conocimiento correcto del _statement_ a probar), por lo que cualquier prueba interactiva de conocimiento nulo es a su vez una prueba interactiva de oraculo.

## Esquema de compromiso de polinomio (_PCS_)
Un esquema de compromiso de polinomio permite a un _committer_ a comprometerse a un polinomio a traves de una _palabra_ que puede usarse para verificar evaluaciones en el mismo. Este compromiso "indirecto" permite al _committer_ a no revelar el polinomio en si. La verificacion del comprimiso al polinomio debe ser eficiente. 
Una vez un _committer_ se compromete con un polinomio, este no puede desligarse del mismo. Un compromiso debe corresponder a un polinomio especifico.

Existen multiples diferentes esquemas, los cuales se diferencias por, entre otros:
- **Setup con o sin confianza**: En los esquemas de setup con confianza se requiren un grupo de participantes en los cuales se confie para que generen ciertos parametros del esquema. Esta generacion dejan 'residuos toxicos' que pueden crear vulnerabilidades. Tambien, los participantes que realizan el setup puede generarlo de manera tal de crear vulnerabilidades. En cambio, en los setup sin confianza, este problema no existe. Por lo general, los esquema de setup sin confianza resultan ser menos eficientes, pues se basan en propiedades criptograficas mas complejas.
- **Escalabilidad**: Los diferentes esquemas pueden escalar de manera diferente frente al polinomio que se busca el compromiso: constante, lineal u otros. Esto hace que la huella en almacenamiento sea diferente entre los diferenes esquemas. 
- **Eficiencia**: Algunos esquemas pueden comprobarse mas rapidamente que otros para el mismo polinomio.
- **Fuerza criptografica**: Que tan resistente es a ataques que busquen conocer la informacion oculta.
Cabe destacar que estas propiedades suelen ser exclusivas una otra a la otra. Es decir, si, por ejemplo, se quiere mas eficiencia, puede ser que se obtenga un esquema mas 'debil' criptograficamente. 

## (ZK-)SNARKs
**(Zero-Knowledge) Succinct Non-Interactive Argument of Knowledge** o Prueba Sucinta No Interactiva de Conocimiento (Nulo), donde sucinta se refiere a que la prueba de conocimiento nulo es mas pequeña que el _testigo_ y puede ser verificada eficientemente. Un protocol (zk-)SNARK es descrito por tres algoritmos:
- **_Gen_** es el setup del algoritmo, generando una _string_ **_CRS_** (_Common Reference String_) usada en el proceso de prueba y una key de verificacion **_VRS_**. Este _setup_ es generalmente hecho por una parte confiable.
- **_Prove_** es el proceso que toma como input **_CRS_**, el _statement_ **_U_** y un _testigo_ **_W_** y da como resultado la prueba **_Pi_**.
- **_Verifiy_** es el proceso que toma como input **_VRS_**, el _statement_ **_U_** y la prueba **_Pi_** y retorna si es aceptada o no.

En zk-SNARKs, esquemas de compromiso de polinomios pueden ser usados con el fin de que sea _sucinto_ y de _conocimiento nulo_, aunque no es la unica estrategia. 


## Aplicaciones
Las aplicaciones de pruebas de conocimiento nulo, y como tal zk-SNARKS son multiples; permiten aumentar la privacidad de una operacion que utiliza datos sensibles. Obviamente esta privacidad viene a un costo, en este caso, rapidez al momento de comprobar la operacion. Algunos ejemplos de sus aplicaciones son:
- **Blockchains y cripto-monedas**: En el caso de las cripto-monedas, permiten realizar transaccion sin revelar quienes son las partes involucradas o la transaccion. [ZCash](https://z.cash/learn/what-are-zk-snarks/) es un ejemplo (y unos de los primeros) de una cripto-moneda que utiliza zk-SNARKs como base de su privacidad. 
- **Blockchains de nivel 2**: Permiten crear blockchains dependientes de una block-chain original (como puede ser Ethereum) donde se realizan transacciones costosas. Una vez se tiene una cantidad de transacciones en la blockchain de nivel 2, estas se juntan y se realiza como una transaccion en la blockchain original. Esto permite flexibilizar (en escalado, velocidad, etc.) la blockchain original a un costo mucho menor.
- **Blockchains de tamaño constante**: Permite crear una blockchain de tamaño constante. Esto permite que los nodos y la red en general tenga una huella mucho mas pequeña (nodos menos poderosos, menos consumo energetico, etc.). En vez de agregar un bloque cada vez, extendiendo asi la red, se guarda la prueba de que la transaccion es correcta. [Coda](https://codaprotocol.com/docs/)
- **Privacidad en aplicaciones / auditorias** zk-SNARKs pueden ser usado para que en aplicaciones donde se use informacion sensible, como datos personales o financieros, sean auditables sin tener que revelar esta informacion.  