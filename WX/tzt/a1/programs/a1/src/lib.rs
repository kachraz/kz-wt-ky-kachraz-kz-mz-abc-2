use anchor_lang::prelude::*;

declare_id!("H1g8cXJBZqv6H2PZw8Hakq3qi6MBBmAUNqmUx3sYH4CW");

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
