#include "Vmips_machine.h"
#include "verilated.h"

void reset();
void iterate();

class Simulation {
public:
    std::unique_ptr<VerilatedContext> context;
    std::unique_ptr<Vmips_machine> top;

    Simulation(int argc, char** argv) : context(new VerilatedContext()) {
        context->commandArgs(argc, argv);
        top = std::make_unique<Vmips_machine>(context.get());
        top->rst_b = 1;
        top->clk = 0;
    }

    void reset() {
        iterate();
        top->rst_b = 0;
        iterate();
        top->rst_b = 1;
    }

    void run() {
        while (notFinished())
            iterate();
    }

    void iterate() {
        context->timeInc(1);
        top->clk = !top->clk;
        top->eval(); 
    }

    bool notFinished() {
        return !context->gotFinish();
    }
};

int main(int argc, char** argv, char** env) {
    Simulation s(argc, argv);

    s.reset();
    s.run();

    return 0;
}


