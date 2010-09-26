##
##  This file is part of the iOSAppsFromScratch project.
##
##  Copyright (C) 2010 Sean Nelson
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
##

#### /Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc-4.2
#### -arch i386
#### -fmessage-length=0 -pipe -std=c99 -Wno-trigraphs -fpascal-strings -fasm-blocks -O0 -Wreturn-type -Wunused-variable
#### -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.1.sdk
#### -fexceptions -fvisibility=hidden -mmacosx-version-min=10.6 -gdwarf-2 -fobjc-abi-version=2 -fobjc-legacy-dispatch
#### -D__IPHONE_OS_VERSION_MIN_REQUIRED=40100 
#### -c /Users/snelson/Documents/Test2/main.m
#### -o /Users/snelson/Documents/Test2/build/Test2.build/Debug-iphonesimulator/Test2.build/Objects-normal/i386/main.o


#### /Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc-4.2
#### -arch i386
#### -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.1.sdk
#### -L/Users/snelson/Documents/iPhoneNavBased/build/Debug-iphonesimulator
#### -F/Users/snelson/Documents/iPhoneNavBased/build/Debug-iphonesimulator
#### -filelist /Users/snelson/Documents/iPhoneNavBased/build/iPhoneNavBased.build/Debug-iphonesimulator/iPhoneNavBased.build/Objects-normal/i386/iPhoneNavBased.LinkFileList
#### -mmacosx-version-min=10.6 -Xlinker -objc_abi_version -Xlinker 2
#### -framework Foundation -framework UIKit -framework CoreGraphics
#### -o /Users/snelson/Documents/iPhoneNavBased/build/Debug-iphonesimulator/iPhoneNavBased.app/iPhoneNavBased

SIMULATE ?= yes

ifeq ($(SIMULATE), yes)

CC := /Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc-4.2
CFLAGS += -arch i386
CFLAGS += -Wno-import -Werror
#CFLAGS += -pipe -std=c99
#CFLAGS += -O0
#CFLAGS += -Wreturn-type -Wunused-variable
#CFLAGS += -Wno-trigraphs
#CFLAGS += -fpascal-strings -fasm-blocks
#CFLAGS += -fexceptions -fvisibility=hidden
#CFLAGS += -fmessage-length=0
#CFLAGS += -gdwarf-2
CFLAGS += -fobjc-abi-version=2
CFLAGS += -fobjc-legacy-dispatch
CFLAGS += -mmacosx-version-min=10.6
CFLAGS += -D__IPHONE_OS_VERSION_MIN_REQUIRED=40100
CFLAGS += -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.1.sdk
LDFLAGS += -Xlinker -objc_abi_version -Xlinker 2
LDFLAGS += -lobjc
LDFLAGS += -framework Foundation -framework UIKit -framework CoreGraphics

else

CC := /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc-4.2
CFLAGS += -Wno-import -Werror
CFLAGS += -arch armv6 -mthumb 
CFLAGS += -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk

endif

CODESIGN_ALLOCATE = /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate

GEN_UUID := EA72E90C-C91B-11DF-8FC4-539D12B3A9FF
## $(uuid | tr '[:lower:]' '[:upper:]')

TARGET := test
OBJS := \
	MobileApp.o \
	MobileAppDelegate.o \
	main.o

default: AppBundle
all: AppBundle

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.m
	$(CC) $(CFLAGS) -c -o $@ $<

clean: 
	rm -rf *.o $(TARGET) $(TARGET).app

AppBundle: code-sign
	mkdir -p $(TARGET).app
	cp Info.plist $(TARGET).app/
	touch $(TARGET).app/PkgInfo
	cp $(TARGET) $(TARGET).app/

code-sign: $(TARGET)
#	codesign -f -s "iPhone Developer" $(TARGET)

install2sim: AppBundle
	mkdir -p ~/Library/Application\ Support/iPhone\ Simulator/4.1/Applications/$(GEN_UUID)
	cp -rf $(TARGET).app ~/Library/Application\ Support/iPhone\ Simulator/4.1/Applications/$(GEN_UUID)/
