distortion(modulo) = process
with
{
    modulo_remover(modulo) = _ <: _ - (_ % int(max(modulo , 1))) : _;

    process = _ : int(_ * 1e5) : modulo_remover(modulo) : float(_) / 1e5 : _;
};


process = distortion(modulo)
with
{
    modulo = 1000;
};
