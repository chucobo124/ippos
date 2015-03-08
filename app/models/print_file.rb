class PrintFile
	require "serialport"
	def serialPrint
		devicePath = "/dev/cu.usbserial"
		boundRay = 9600
		bitSize = 8
		closeBit = 1 
		mode = SerialPort::NONE
		serialPrint = SerialPort.new(devicePath, boundRay, bitSize,closeBit,mode)
	end
	def printFileLeftRaw(file)
		serialPrint.write(file+"\n")
	end
	def printFileRighttRaw(file)
		serialPrint.write("        "+file+"\n")
	end
	def printFileCut
		serialPrint.write("\f")
	end
end