pragma solidity ^0.8.13;

function ch(bytes4 x, bytes4 y, bytes4 z) pure returns (bytes4) {
    return (x & y) ^ ((~x) & z);
}

function maj(bytes4 x, bytes4 y, bytes4 z) pure returns (bytes4) {
    return (x & y) ^ (x & z) ^ (y & z);
}

function rotate_right_w32(bytes4 x, uint8 n) pure returns (bytes4) {
    return (x >> n) | (x << (32 - n));
}

function shift_right_w32(bytes4 x, uint8 n) pure returns (bytes4) {
    return x >> n;
}

/**
 * Reinterpret a 256 bit number as a 32bit-word
 */
function uint32_to_bytes4(uint32 x) pure returns (bytes4) {
    return bytes4(x);
}

/**
 * Sum multiple 32bit-words as if they were number in mod 2^32, then reinterpret the result as a new word
 */
function sum_w32(bytes4[2] memory words) pure returns (bytes4) {
    uint32 acc = 0;
    for (uint32 i = 0; i < 2; i++) {
        unchecked {
            acc += uint32(words[i]);
        }
    }

    return uint32_to_bytes4(acc);
}

/**
 * Sum multiple 32bit-words as if they were number in mod 2^32, then reinterpret the result as a new word
 */
function sum_w32(bytes4[3] memory words) pure returns (bytes4) {
    uint32 acc = 0;
    for (uint32 i = 0; i < 3; i++) {
        unchecked {
            acc += uint32(words[i]);
        }
    }

    return uint32_to_bytes4(acc);
}

/**
 * Sum multiple 32bit-words as if they were number in mod 2^32, then reinterpret the result as a new word
 */
function sum_w32(bytes4[4] memory words) pure returns (bytes4) {
    uint32 acc = 0;
    for (uint32 i = 0; i < 4; i++) {
        unchecked {
            acc += uint32(words[i]);
        }
    }
    return uint32_to_bytes4(acc);
}

/**
 * Sum multiple 32bit-words as if they were number in mod 2^32, then reinterpret the result as a new word
 */
function sum_w32(bytes4[5] memory words) pure returns (bytes4) {
    uint32 acc = 0;
    for (uint32 i = 0; i < words.length; i++) {
        unchecked {
            acc += uint32(words[i]);
        }
    }

    return uint32_to_bytes4(acc);
}


/**
 * Function to be used while preparing the schedule for SHA-256
 */
function mix(bytes4[] memory w, uint32 t) pure returns (bytes4) {
    bytes4 s0 = rotate_right_w32(w[t - 15], 7) ^
        rotate_right_w32(w[t - 15], 18) ^
        shift_right_w32(w[t - 15], 3);
    bytes4 s1 = rotate_right_w32(w[t - 2], 17) ^
        rotate_right_w32(w[t - 2], 19) ^
        shift_right_w32(w[t - 2], 10);

    return sum_w32([s0, w[t - 7], s1, w[t - 16]]);
}
struct PartialState{
    bytes4 a;
    bytes4 b;
    bytes4 c;
    bytes4 d;
    bytes4 e;
    bytes4 f;
    bytes4 g;
    bytes4 h;
}

function _sha_round(bytes4[] memory w, PartialState memory p, bytes4[64] memory k) pure returns (PartialState memory){
    for(uint8 i = 0; i < 64; i++){
        bytes4 t1 = sum_w32([
            p.h, 
            rotate_right_w32(p.e, 6) ^ rotate_right_w32(p.e, 11) ^ rotate_right_w32(p.e, 25), 
            ch(p.e, p.f, p.g), 
            w[i], 
            k[i]
        ]);
        bytes4 a = sum_w32([
            t1, 
            rotate_right_w32(p.a, 2) ^ rotate_right_w32(p.a, 13) ^ rotate_right_w32(p.a, 22), 
            maj(p.a, p.b, p.c)
        ]);
        
        p.h = p.g;
        p.g = p.f;
        p.f = p.e;
        p.e = sum_w32([p.d, t1]);
        p.d = p.c;
        p.c = p.b;
        p.b = p.a;
        p.a = a;
    }


    return p;
}
/**
 * Perform a round in the SHA-256 schedule based on the previous state of the hash.
 * Returns the next state of the hash
 */
function sha_round(
    bytes4[] memory w,
    bytes32 current_state
) pure returns (bytes32) {
    require(w.length == 64);
    bytes4[64] memory constants = [
        bytes4(0x428a2f98),
        bytes4(0x71374491),
        bytes4(0xb5c0fbcf),
        bytes4(0xe9b5dba5),
        bytes4(0x3956c25b),
        bytes4(0x59f111f1),
        bytes4(0x923f82a4),
        bytes4(0xab1c5ed5),
        bytes4(0xd807aa98),
        bytes4(0x12835b01),
        bytes4(0x243185be),
        bytes4(0x550c7dc3),
        bytes4(0x72be5d74),
        bytes4(0x80deb1fe),
        bytes4(0x9bdc06a7),
        bytes4(0xc19bf174),
        bytes4(0xe49b69c1),
        bytes4(0xefbe4786),
        bytes4(0x0fc19dc6),
        bytes4(0x240ca1cc),
        bytes4(0x2de92c6f),
        bytes4(0x4a7484aa),
        bytes4(0x5cb0a9dc),
        bytes4(0x76f988da),
        bytes4(0x983e5152),
        bytes4(0xa831c66d),
        bytes4(0xb00327c8),
        bytes4(0xbf597fc7),
        bytes4(0xc6e00bf3),
        bytes4(0xd5a79147),
        bytes4(0x06ca6351),
        bytes4(0x14292967),
        bytes4(0x27b70a85),
        bytes4(0x2e1b2138),
        bytes4(0x4d2c6dfc),
        bytes4(0x53380d13),
        bytes4(0x650a7354),
        bytes4(0x766a0abb),
        bytes4(0x81c2c92e),
        bytes4(0x92722c85),
        bytes4(0xa2bfe8a1),
        bytes4(0xa81a664b),
        bytes4(0xc24b8b70),
        bytes4(0xc76c51a3),
        bytes4(0xd192e819),
        bytes4(0xd6990624),
        bytes4(0xf40e3585),
        bytes4(0x106aa070),
        bytes4(0x19a4c116),
        bytes4(0x1e376c08),
        bytes4(0x2748774c),
        bytes4(0x34b0bcb5),
        bytes4(0x391c0cb3),
        bytes4(0x4ed8aa4a),
        bytes4(0x5b9cca4f),
        bytes4(0x682e6ff3),
        bytes4(0x748f82ee),
        bytes4(0x78a5636f),
        bytes4(0x84c87814),
        bytes4(0x8cc70208),
        bytes4(0x90befffa),
        bytes4(0xa4506ceb),
        bytes4(0xbef9a3f7),
        bytes4(0xc67178f2)
    ];
    PartialState memory p = _sha_round(
        w, 
        PartialState({
            a: bytes4(current_state),
            b: bytes4(current_state << 32),
            c: bytes4(current_state << 64),
            d: bytes4(current_state << 96),
            e: bytes4(current_state << 128),
            f: bytes4(current_state << 160),
            g: bytes4(current_state << 192),
            h: bytes4(current_state << 224)
        }),
        constants
    );
    bytes32 result;

    result |= bytes32(sum_w32([bytes4(current_state), p.a])) >> 0;
    result |= bytes32(sum_w32([bytes4(current_state << 32), p.b])) >> 32;
    result |= bytes32(sum_w32([bytes4(current_state << 64), p.c])) >> 64;
    result |= bytes32(sum_w32([bytes4(current_state << 96), p.d])) >> 96;
    result |= bytes32(sum_w32([bytes4(current_state << 128), p.e])) >> 128;
    result |= bytes32(sum_w32([bytes4(current_state << 160), p.f])) >> 160;
    result |= bytes32(sum_w32([bytes4(current_state << 192), p.g])) >> 192;
    result |= bytes32(sum_w32([bytes4(current_state << 224), p.h])) >> 224;

    return result;
}

/**
 * Reinterprets bytes into 32bit-words and add the extra space necessary for the schedule
 */
function chunk_to_schedule(bytes memory chunk) pure returns (bytes4[] memory) {
    require(chunk.length == 64);
    bytes4[] memory schedule = new bytes4[](64);
    for (uint i = 0; i < 16; i++) {
        schedule[i] |= bytes4(chunk[i * 4]) >> 0;
        schedule[i] |= bytes4(chunk[i * 4 + 1]) >> 8;
        schedule[i] |= bytes4(chunk[i * 4 + 2]) >> 16;
        schedule[i] |= bytes4(chunk[i * 4 + 3]) >> 24;
    }
    return schedule;
}

function slice(
    bytes memory input,
    uint start,
    uint end
) pure returns (bytes memory) {
    require(input.length >= end && end > start);
    bytes memory copy = new bytes(end - start);

    for (uint i = start; i < end; i++) {
        copy[i - start] = input[i];
    }

    return copy;
}

/**
 * Retrieves a chunk from the input and "append the bit '1' to the end of the message"
 */
function slice_then_append_bit_1(
    bytes memory input,
    uint chunk_start,
    uint chunk_end
) pure returns (bytes memory) {
    require(chunk_end - chunk_start <= 64 && input.length >= chunk_end && chunk_end > chunk_start);
    bytes memory copy = new bytes(64);
    uint chunk_length = chunk_end - chunk_start;

    for (uint i = chunk_start; i < chunk_end; i++) {
        copy[i - chunk_start] = input[i];
    }

    copy[chunk_length] = bytes1(0x80);
    return copy;
}

/**
 * Appends the amount of bits in the original message at the end of the padded chunk
 */
function insert_len(
    bytes memory chunk,
    uint64 total_len
) pure returns (bytes memory) {
    bytes8 byte_len = bytes8(total_len * 8);
    for (uint i = 56; i < 64; i++) {
        chunk[i] = byte_len[i - 56];
    }
    return chunk;
}

/**
 * Perform a full round in a 64 byte chunk (or 16 32bit-words) of the already padded message.
 * Create the schedule then run it through a round to get the new state of the hash
 */
function do_64bytes_chunk(
    bytes memory chunk,
    bytes32 curr_hash
) pure returns (bytes32) {
    require(chunk.length == 64);
    bytes4[] memory schedule = chunk_to_schedule(chunk);
    for (uint32 t = 16; t < 64; t++) {
        schedule[t] = mix(schedule, t);
    }
    return sha_round(schedule, curr_hash);
}

/**
 * Checks if the chunk needs to be padded, then runs the necessary amount of sha rounds
 */
function do_chunk(
    bytes memory input,
    uint chunk_start,
    uint chunk_end,
    bytes32 curr_hash,
    uint64 total_len
) pure returns (bytes32) {
    require(input.length == total_len && input.length >= chunk_end && chunk_end > chunk_start);
    uint chunk_length = chunk_end - chunk_start;

    if (chunk_length < 56) {
        // This is the final block, and it can be padded without creating a new block
        bytes memory chunk = insert_len(
            slice_then_append_bit_1(input, chunk_start, chunk_end),
            total_len
        );
        return do_64bytes_chunk(chunk, curr_hash);
    } else if (chunk_length < 64) {
        //This is the final block, but it cannot be padded without creating a new block
        //Create the new block, then do 2 rounds of the hash
        bytes memory chunk_one = slice_then_append_bit_1(input, chunk_start, chunk_end);
        bytes memory chunk_two = insert_len(new bytes(64), total_len);
        return
            do_64bytes_chunk(chunk_two, do_64bytes_chunk(chunk_one, curr_hash));
    } else if (chunk_length == 64 && chunk_end >= total_len) {
        //This means is the last block, but it's exactly 64 bytes long.
        //Create a new block, then insert the padding in there, do the 2 rounds of hashing
        bytes memory chunk_two = new bytes(64);
        chunk_two[0] = bytes1(0x80);
        chunk_two = insert_len(chunk_two, total_len);
        return
            do_64bytes_chunk(
                chunk_two,
                do_64bytes_chunk(
                    slice(input, chunk_start, chunk_end),
                    curr_hash
                )
            );
    } else {
        //Normal hashing round
        return
            do_64bytes_chunk(slice(input, chunk_start, chunk_end), curr_hash);
    }
}

function tp_sha256(bytes memory input) pure returns (bytes32) {
    require(input.length < 2**64);
    uint64 total_len = uint64(input.length);
    bytes32 curr_hash = 0x6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;

    if(input.length == 0){
        bytes memory empty_chunk = new bytes(64);
        empty_chunk[0] = 0x80;
        curr_hash = do_64bytes_chunk(empty_chunk, curr_hash);
    }

    for (uint i = 0; i < input.length; i += 64) {
        uint offset = i + 64 > input.length ? input.length : i + 64;
        curr_hash = do_chunk(input, i, offset, curr_hash, total_len);
    }

    return curr_hash;
}