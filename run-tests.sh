#!/bin/bash

# Run the test suite for all supported swift versions
swift test -Xswiftc -swift-version -Xswiftc 5
swift test -Xswiftc -swift-version -Xswiftc 4.2
swift test -Xswiftc -swift-version -Xswiftc 4
