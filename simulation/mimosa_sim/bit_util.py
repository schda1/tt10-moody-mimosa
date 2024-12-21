def read_bit(x, n: int):
    """
    Read the n-th bit of the number x
    """
    return (x & (1 << n)) >> n


def def_bit(x, n: int, val: int):
    """
    Define the n-bit of the number x as value
    """
    return set_bit(int(x), n) if val else clr_bit(int(x), n)


def set_bit(x, n: int) -> int:
    """
    Set the n-bit of the number x
    """
    return x | (1 << n)


def clr_bit(x, n: int) -> int:
    """
    Clear the n-bit of the number x
    """
    return x & ~(1 << n)
