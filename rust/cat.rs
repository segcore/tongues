use std::io;
use std::process::ExitCode;

fn main() -> ExitCode {
    let copied: io::Result::<u64> = io::copy(&mut io::stdin(), &mut io::stdout());
    if let Err(error) = copied {
        eprintln!("Failed to copy input to output: {}", error);
        return ExitCode::FAILURE;
    }
    ExitCode::SUCCESS
}
