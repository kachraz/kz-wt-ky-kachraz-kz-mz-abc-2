use anchor_lang::prelude::*;

declare_id!("CutBNQ6f7QMDz3XjnJ6PGSdsxxU4N1N96kUMCTUxvsBq");

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
