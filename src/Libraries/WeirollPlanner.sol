library WeirollPlanner {
    error InvalidIndex();

    uint256 constant maxIndex = (2 ** 7) - 2;
    uint8 constant USE_STATE = 0xfe;
    uint8 constant END_OF_ARGS = 0xff;

    enum CallType {
        DelegateCall,
        Call,
        StaticCall,
        CallWithValue
    }

    function encodeCommand(bytes4 selector, uint8 flags, uint48 inp, uint8 o, address target)
        internal
        pure
        returns (bytes32)
    {
        uint256 ret = 0;
        ret |= uint256(bytes32(selector));
        ret |= uint256(flags) << (27 * 8);
        ret |= uint256(inp) << (21 * 8);
        ret |= uint256(o) << (20 * 8);
        ret |= uint256(uint160(target));
        return bytes32(ret);
        //
        // return bytes32(selector) | (flags >> (4 * 8)) | (inp >> (5 * 8)) | (o >> (11 * 8))
        //     | bytes32(uint256(uint160(target)));
    }

    function encodeFlag(bool tup, bool isExtendedCommand, CallType callType) internal returns (uint8) {
        // 1000 0000 => 0x80
        // 0100 0000 => 0x40
        // 0000 0000 => 0x00
        // 0000 0001 => 0x01
        // 0000 0010 => 0x02
        // 0000 0011 => 0x03
        return (tup ? 0x80 : 0x00) | (isExtendedCommand ? 0x40 : 0x00) | uint8(callType);
    }

    function encodeInput(uint8 a1, uint8 a2, uint8 a3, uint8 a4, uint8 a5, uint8 a6) internal returns (uint48) {
        return uint48(
            (uint256(a1) << (5 * 8)) | (uint256(a2) << (4 * 8)) | (uint256(a3) << (3 * 8)) | (uint256(a4) << (2 * 8))
                | (uint256(a5) << (1 * 8)) | uint256(a6)
        );
    }

    function encodeInputArg(bool isFixed, uint8 idx) internal returns (uint8) {
        if (idx > maxIndex) revert InvalidIndex();
        return (isFixed ? 0x00 : 0x80) | idx;
    }
}
