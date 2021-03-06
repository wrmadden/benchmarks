
package avroEncode_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   print '/* Additional includes go here  */', "\n";
   print "\n";
   SPL::CodeGenHelper::implementationPrologueImpl($model,0,3);
   print "\n";
   print '#include "emailavro/email.hh"			// Definition of the Avro schema structures', "\n";
   print '#include "avro/Encoder.hh"	// Avro functions', "\n";
   print '#include "avro/Decoder.hh"	// Avro functions', "\n";
   print '#include "avro/Reader.hh" 	// Avro functions', "\n";
   print "\n";
   print 'using namespace std;', "\n";
   print 'using namespace SPL;', "\n";
   print "\n";
   print '// Constructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::MY_OPERATOR()', "\n";
   print '{', "\n";
   print '    // Initialization code goes here   ', "\n";
   print '}', "\n";
   print "\n";
   print '// Destructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::~MY_OPERATOR() ', "\n";
   print '{', "\n";
   print '    // Finalization code goes here', "\n";
   print '}', "\n";
   print "\n";
   print '// Notify port readiness', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::allPortsReady() ', "\n";
   print '{', "\n";
   print '    // Notifies that all ports are ready. No tuples should be submitted before', "\n";
   print '    // this. Source operators can use this method to spawn threads.', "\n";
   print "\n";
   print '    /*', "\n";
   print '      createThreads(1); // Create source thread', "\n";
   print '    */', "\n";
   print '}', "\n";
   print ' ', "\n";
   print '// Notify pending shutdown', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::prepareToShutdown() ', "\n";
   print '{', "\n";
   print '    // This is an asynchronous call', "\n";
   print '}', "\n";
   print "\n";
   print '// Processing for source and threaded operators   ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(uint32_t idx)', "\n";
   print '{', "\n";
   print '    // A typical implementation will loop until shutdown', "\n";
   print '    /*', "\n";
   print '      while(!getPE().getShutdownRequested()) {', "\n";
   print '          // do work ...', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for mutating ports ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print "\n";
   print '    // Declare a local C++ email structure according to our Avro schema in email.hh', "\n";
   print '    // email.hh is generated using avrogencpp', "\n";
   print '    c::Email emailLocal;', "\n";
   print '    ', "\n";
   print '    // Extract the fields from the email passed in as a tuple into the C++ structure', "\n";
   print '    IPort0Type & ituple = static_cast<IPort0Type &>(tuple);', "\n";
   print '	', "\n";
   print '    emailLocal.ID      = ituple.get_ID();', "\n";
   print '    emailLocal.From    = ituple.get_From();', "\n";
   print '    emailLocal.Date    = ituple.get_Date();', "\n";
   print '    emailLocal.Subject = ituple.get_Subject();', "\n";
   print '    emailLocal.ToList  = ituple.get_ToList();', "\n";
   print '    emailLocal.CcList  = ituple.get_CcList();', "\n";
   print '    emailLocal.BccList = ituple.get_BccList();', "\n";
   print '    emailLocal.Body    = ituple.get_Body();	', "\n";
   print '	', "\n";
   print '    // Create an Avro output stream in memory', "\n";
   print '    std::auto_ptr<avro::OutputStream> out = avro::memoryOutputStream();', "\n";
   print '	', "\n";
   print '    // Create an avro encoder', "\n";
   print '    avro::EncoderPtr e = avro::binaryEncoder();', "\n";
   print '    e->init(*out);', "\n";
   print '	', "\n";
   print '    // Avro encode the email', "\n";
   print '    avro::encode(*e, emailLocal);', "\n";
   print '	', "\n";
   print '    // Flush any internal buffers', "\n";
   print '    e->flush();', "\n";
   print '	', "\n";
   print '    // Get a count of the number of bytes in the Avro encoded stream', "\n";
   print '    uint64_t count = out->byteCount();', "\n";
   print '	', "\n";
   print '    // Create an Avro input stream in memory reading from the earlier output stream', "\n";
   print '    std::auto_ptr<avro::InputStream> in = avro::memoryInputStream(*out);', "\n";
   print '    avro::StreamReader* reader = new avro::StreamReader( *in);', "\n";
   print '	', "\n";
   print '    // Malloc some memory of size count - determined earlier', "\n";
   print '    unsigned char * ptr;', "\n";
   print '    ptr = (unsigned char *) malloc ( count);', "\n";
   print '		', "\n";
   print '    // Read count bytes from the stream into our allocated memory', "\n";
   print '    reader->readBytes( ptr, count);', "\n";
   print '    // The Avro encoded stream is now in our locally allocated memory', "\n";
   print '    // Submit the resulting blob to the output port', "\n";
   print '    // Need to update the blob in the original input tuple with the new data', "\n";
   print '    // Define a tuple that we\'re going to submit', "\n";
   print '    OPort0Type otuple;', "\n";
   print '    otuple.get_Avro().adoptData( ptr, count);', "\n";
   print '    submit( otuple, 0);', "\n";
   print '	', "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for non-mutating ports', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple const & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print '    // Sample submit code', "\n";
   print '    /* ', "\n";
   print '      OPort0Type otuple;', "\n";
   print '      submit(otuple, 0); // submit to output port 0', "\n";
   print '    */', "\n";
   print '    // Sample cast code', "\n";
   print '    /*', "\n";
   print '    switch(port) {', "\n";
   print '    case 0: { ', "\n";
   print '      IPort0Type const & ituple = static_cast<IPort0Type const&>(tuple);', "\n";
   print '      ...', "\n";
   print '    } break;', "\n";
   print '    case 1: { ', "\n";
   print '      IPort1Type const & ituple = static_cast<IPort1Type const&>(tuple);', "\n";
   print '      ...', "\n";
   print '    } break;', "\n";
   print '    default: ...', "\n";
   print '    }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   print '// Punctuation processing', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Punctuation const & punct, uint32_t port)', "\n";
   print '{', "\n";
   print '    /*', "\n";
   print '      if(punct==Punctuation::WindowMarker) {', "\n";
   print '        // ...;', "\n";
   print '      } else if(punct==Punctuation::FinalMarker) {', "\n";
   print '        // ...;', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   SPL::CodeGenHelper::implementationEpilogueImpl($model, 0);
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
