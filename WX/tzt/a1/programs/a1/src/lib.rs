use anchor_lang::prelude::*;

declare_id!("7WpuY6r6vwyfsmxbkhBxB7Nxzg7szk39qG8JJDP9mvFo");

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
