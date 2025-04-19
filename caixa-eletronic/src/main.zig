const std = @import("std");

const Conta = struct {
    saldo: f64,

    pub fn nova() Conta {
        return Conta{ .saldo = 0.0 };
    }

    pub fn verSaldo(self: *Conta) void {
        std.debug.print("Saldo atual: R$ {:.2}\n", .{self.saldo});
    }

    pub fn depositar(self: *Conta, valor: f64) void {
        if (valor <= 0) {
            std.debug.print("Valor inválido para depósito.\n", .{});
            return;
        }
        self.saldo += valor;
        std.debug.print("Depósito de R$ {:.2} realizado.\n", .{valor});
    }

    pub fn sacar(self: *Conta, valor: f64) void {
        if (valor <= 0) {
            std.debug.print("Valor inválido para saque.\n", .{});
            return;
        }
        if (valor > self.saldo) {
            std.debug.print("Saldo insuficiente para saque.\n", .{});
            return;
        }
        self.saldo -= valor;
        std.debug.print("Saque de R$ {:.2} realizado.\n", .{valor});
    }
};

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();
    var conta = Conta.nova();
    var buf: [100]u8 = undefined;

    while (true) {
        try stdout.print("===== Caixa Eletronico =====\n", .{});
        try stdout.print("1. Ver saldo\n", .{});
        try stdout.print("2. Depositar\n", .{});
        try stdout.print("3. Sacar\n", .{});
        try stdout.print("4. Sair\n", .{});
        try stdout.print("Escolha uma opcao: ", .{});

        const linha = try stdin.readUntilDelimiterOrEof(&buf, '\n');
        if (linha == null) break;
        const opcao = std.mem.trim(u8, linha.?, " \r\n");

        if (std.mem.eql(u8, opcao, "1")) {
            conta.verSaldo();
        } else if (std.mem.eql(u8, opcao, "2")) {
            try stdout.print("Digite o valor para depositar: ", .{});
            const valorStr = try stdin.readUntilDelimiterOrEof(&buf, '\n');
            if (valorStr) |vs| {
                const valor = std.fmt.parseFloat(f64, std.mem.trim(u8, vs, " \r\n")) catch {
                    std.debug.print("Valor invalido.\n", .{});
                    continue;
                };
                conta.depositar(valor);
            }
        } else if (std.mem.eql(u8, opcao, "3")) {
            try stdout.print("Digite o valor para sacar: ", .{});
            const valorStr = try stdin.readUntilDelimiterOrEof(&buf, '\n');
            if (valorStr) |vs| {
                const valor = std.fmt.parseFloat(f64, std.mem.trim(u8, vs, " \r\n")) catch {
                    std.debug.print("Valor invalido.\n", .{});
                    continue;
                };
                conta.sacar(valor);
            }
        } else if (std.mem.eql(u8, opcao, "4")) {
            std.debug.print("Saindo...\n", .{});
            break;
        } else {
            std.debug.print("Opçao invalida.\n", .{});
        }
    }
}
