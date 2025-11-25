<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserModelTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function new_users_created_by_factory_have_user_role()
    {
        $user = User::factory()->create();

        $this->assertEquals('user', $user->role);
    }

    /** @test */
    public function admin_role_is_recognized_correctly()
    {
        $admin = User::factory()->create([
            'role' => 'admin',
        ]);

        $this->assertEquals('admin', $admin->role);
    }
}
