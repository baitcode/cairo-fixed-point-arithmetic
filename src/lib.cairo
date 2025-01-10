use starknet::storage_access::{StorePacking};
use core::num::traits::{WideMul, Zero};
use core::integer::{u512, u512_safe_div_rem_by_u256 };

pub const EPSILON: u256 = 0x10_u256;

// 2^124
                           
pub const MAX_INT: u128 = 0x8000000000000110000000000000000_u128;
pub const HALF: u128    = 0x80000000000000000000000000000000_u128;

// 124.128 (= 252 which 1 felt exactly) 
#[derive(Debug, Drop, Copy, Serde)]
pub struct UFixedPoint123x128 { 
    value: u256
}   

pub mod Errors {
    pub const FP_ADD_OVERFLOW: felt252 = 'FP_ADD_OVERFLOW';
    pub const FP_SUB_OVERFLOW: felt252 = 'FP_SUB_OVERFLOW';
    pub const FP_MUL_OVERFLOW: felt252 = 'FP_MUL_OVERFLOW';
    pub const FP_DIV_OVERFLOW: felt252 = 'FP_DIV_OVERFLOW';
    pub const FP_SUB_UNDERFLOW: felt252 = 'FP_SUB_UNDERFLOW';
    pub const FELT_OVERFLOW: felt252 = 'FELT_OVERFLOW';
    pub const INT_VALUE_OVERFLOW: felt252 = 'INT_VALUE_OVERFLOW';
    pub const DIVISION_BY_ZERO: felt252 = 'DIVISION_BY_ZERO';
}

pub impl UFixedPoint123x128StorePacking of StorePacking<UFixedPoint123x128, felt252> {
    fn pack(value: UFixedPoint123x128) -> felt252 {
        value.try_into().expect(Errors::FELT_OVERFLOW)
    }

    fn unpack(value: felt252) -> UFixedPoint123x128 {
        value.into()
    }
}

pub impl UFixedPoint123x128PartialEq of PartialEq<UFixedPoint123x128> {
    fn eq(lhs: @UFixedPoint123x128, rhs: @UFixedPoint123x128) -> bool {
        let left: u256 = (*lhs).value;
        let right: u256 = (*rhs).value;

        let diff = if left > right {
            left - right 
        } else {
            right - left
        };
        
        diff < EPSILON
    }
}

pub impl UFixedPoint123x128Zero of Zero<UFixedPoint123x128> {
    fn zero() -> UFixedPoint123x128 {
        UFixedPoint123x128 { 
            value: u256 {
                low: 0,
                high: 0,
            }
        }
    }

    fn is_zero(self: @UFixedPoint123x128) -> bool {
        self.value.is_zero()
    }

    fn is_non_zero(self: @UFixedPoint123x128) -> bool { !self.is_zero() }
}

pub(crate) impl U256IntoUFixedPoint of Into<u256, UFixedPoint123x128> {
    fn into(self: u256) -> UFixedPoint123x128 { UFixedPoint123x128 { value: self } }
}

pub(crate) impl UFixedPointIntoU256 of Into<UFixedPoint123x128, u256> {
    fn into(self: UFixedPoint123x128) -> u256 { self.value }
}

pub(crate) impl Felt252IntoUFixedPoint of Into<felt252, UFixedPoint123x128> {
    fn into(self: felt252) -> UFixedPoint123x128 { 
        let medium: u256 = self.into();
        medium.into()
    }
}

#[generate_trait]
pub impl UFixedPoint123x128Impl of UFixedPointTrait {
    fn get_integer(self: UFixedPoint123x128) -> u128 { self.value.high }
    fn get_fractional(self: UFixedPoint123x128) -> u128 { self.value.low }
    
    fn round(self: UFixedPoint123x128) -> u128 {
        self.get_integer() + if (self.get_fractional() >= HALF) {
            1
        } else {
            0
        }
    }
}

pub(crate) impl UFixedPoint123x128IntoFelt252 of TryInto<UFixedPoint123x128, felt252> {
    fn try_into(self: UFixedPoint123x128) -> Option<felt252> { 
        self.value.try_into()
    }
}

pub impl UFixedPoint123x128ImplAdd of Add<UFixedPoint123x128> {
    fn add(lhs: UFixedPoint123x128, rhs: UFixedPoint123x128) -> UFixedPoint123x128 {
        assert(rhs.value <= rhs.value + lhs.value, Errors::FP_ADD_OVERFLOW);
        assert(lhs.value <= rhs.value + lhs.value, Errors::FP_ADD_OVERFLOW);
        
        let res = UFixedPoint123x128 {
            value: rhs.value + lhs.value
        };
        assert(res.value.high < MAX_INT, Errors::FP_ADD_OVERFLOW);
        
        res
    }
}

pub impl UFixedPoint123x128ImplSub of Sub<UFixedPoint123x128> {
    fn sub(lhs: UFixedPoint123x128, rhs: UFixedPoint123x128) -> UFixedPoint123x128 {
        assert(lhs.value >= rhs.value, Errors::FP_SUB_UNDERFLOW);
        // TODO: underflow checking
        let res = UFixedPoint123x128 {
            value: lhs.value - rhs.value
        };
        assert(res.value.high < MAX_INT, Errors::FP_SUB_OVERFLOW);

        res
    }
}


pub impl UFixedPoint123x128ImplMul of Mul<UFixedPoint123x128> {
    fn mul(lhs: UFixedPoint123x128, rhs: UFixedPoint123x128) -> UFixedPoint123x128 {
        let mult_res = lhs.value.wide_mul(rhs.into());

        let res = UFixedPoint123x128 {
            value: u256 {
                low: mult_res.limb1,
                high: mult_res.limb2,
            }
        };

        assert(res.value.high < MAX_INT, Errors::FP_MUL_OVERFLOW);

        res
    }
}
pub impl UFixedPoint123x128ImplDiv of Div<UFixedPoint123x128> {
    fn div(lhs: UFixedPoint123x128, rhs: UFixedPoint123x128) -> UFixedPoint123x128 {        
        let left: u512 = u512 {
            limb0: 0,
            limb1: 0,
            limb2: lhs.value.low,
            limb3: lhs.value.high,
        };
        
        assert(rhs.value != 0, Errors::DIVISION_BY_ZERO);
        
        let (div_res, _) = u512_safe_div_rem_by_u256(
            left,
            rhs.value.try_into().unwrap(),
        );

        let res = UFixedPoint123x128 { 
            value: u256 {
                low: div_res.limb1,
                high: div_res.limb2,
            }
        };
        
        assert(res.value.high < MAX_INT, Errors::FP_DIV_OVERFLOW);

        res
    }
}

pub fn div_u64_by_u128(lhs: u64, rhs: u128) -> UFixedPoint123x128 {
    assert(!rhs.is_zero(), Errors::DIVISION_BY_ZERO);
    
    // lhs >> 128
    let left: u256 = u256 {
        low: 0,
        high: lhs.into(),
    };

    let res = UFixedPoint123x128 {
        value: left / rhs.into()
    };

    assert(res.value.high < MAX_INT, Errors::FP_DIV_OVERFLOW);

    res
}

pub fn div_u64_by_fixed_point(lhs: u64, rhs: UFixedPoint123x128) -> UFixedPoint123x128 {
    assert(!rhs.is_zero(), Errors::DIVISION_BY_ZERO);
    
    lhs.into() / rhs
}

pub fn mul_fixed_point_by_u128(lhs: UFixedPoint123x128, rhs: u128) -> UFixedPoint123x128 {
    let mult_res = lhs.value.wide_mul(rhs.into());

    let res = UFixedPoint123x128 {
        value: u256 {
            low: mult_res.limb0,
            high: mult_res.limb1,
        }
    };

    assert(res.value.high < MAX_INT, Errors::FP_MUL_OVERFLOW);

    res
}

pub impl U64IntoUFixedPoint of Into<u64, UFixedPoint123x128> {
    fn into(self: u64) -> UFixedPoint123x128 { 
        UFixedPoint123x128 { 
            value: u256 {
                low: 0,            // fractional 
                high: self.into(), // integer
            }
        } 
    }
}

pub impl U128IntoUFixedPoint of Into<u128, UFixedPoint123x128> {
    fn into(self: u128) -> UFixedPoint123x128 { 
        assert(self < MAX_INT, Errors::INT_VALUE_OVERFLOW);
        
        let medium = u256 {
            low: 0,
            high: self,
        };
        medium.into()
    }
}

#[cfg(test)]
mod fp_test;
