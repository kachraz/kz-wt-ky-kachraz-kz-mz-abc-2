use anchor_lang::prelude::*;

declare_id!("5cArbGqLdr1T6FPZFqb6eDKAHjUMqEzjKDkqSBuLc1br");

#[program]
pub mod a1 {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
