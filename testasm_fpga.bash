echo "RTL simulation"
testasm -d example.asm
testasm -d dual.llsc.asm
testasm -d test.coherence1.asm
testasm -d test.coherence2.asm

echo "RTL simulation"
testasm -ds example.asm
testasm -ds dual.llsc.asm
testasm -ds test.coherence1.asm
testasm -ds test.coherence2.asm

(asm asmFiles/example.asm && sim -t -c && synthesize -d -m system_fpga && diff -y memsim.hex memfpga.hex && diff memsim.hex memfpga.hex) > output.txt
diffvar=$(diff memsim.hex memfpga.hex)

if [ $diffvar = ""]; then
   echo "example success"
else
   echo "example failed"
fi


(asm asmFiles/dual.llsc.asm && sim -t -c && synthesize -d -m system_fpga && diff -y memsim.hex memfpga.hex && diff memsim.hex memfpga.hex) > output.txt
diffvar=$(diff memsim.hex memfpga.hex)

if [ $diffvar = ""]; then
   echo "dual.llsc success"
else
   echo "dual.llsc failed"
fi


(asm asmFiles/test.coherence1.asm && sim -t -c && synthesize -d -m system_fpga && diff -y memsim.hex memfpga.hex && diff memsim.hex memfpga.hex) > output.txt
diffvar=$(diff memsim.hex memfpga.hex)

if [ $diffvar = ""]; then
   echo "test.coherence1 success"
else
   echo "test.coherence1 failed"
fi


(asm asmFiles/test.coherence2.asm && sim -t -c && synthesize -d -m system_fpga && diff -y memsim.hex memfpga.hex && diff memsim.hex memfpga.hex) > output.txt
diffvar=$(diff memsim.hex memfpga.hex)

if [ $diffvar = ""]; then
   echo "test.coherence2 success"
else
   echo "test.coherence2 failed"
fi

exit 1
